# Apache Web Server with a simple web page
module "ec2_instance" {
  source                      = "terraform-aws-modules/ec2-instance/aws"
  version                     = "5.6.1"
  name                        = format("%s-%s", var.ec2_instance_name, local.name_suffix)
  instance_type               = var.ec2_instance_type
  ami_ssm_parameter           = var.ec2_ami_ssm_parameter
  vpc_security_group_ids      = [module.security_group.security_group_id]
  user_data                   = file("${path.module}/ec2-user-data.sh")
  user_data_replace_on_change = true
  create_iam_instance_profile = true
  iam_role_use_name_prefix    = false
  iam_role_description        = "IAM role for EC2 instance to read from S3"
  iam_role_policies = {
    AmazonS3ReadOnlyAccess = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
  }
}

# Security group used to allow HTTP traffic to Web Server and SSH to manage
module "security_group" {
  source              = "terraform-aws-modules/security-group/aws"
  version             = "5.1.2"
  name                = format("%s-%s", "web-dmz", local.name_suffix)
  use_name_prefix     = false
  description         = "Security group for web server"
  vpc_id              = data.aws_vpc.default.id
  egress_rules        = ["all-all"]
  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["http-80-tcp"]
  ingress_with_cidr_blocks = [
    {
      description = "SSH"
      rule        = "ssh-tcp"
      cidr_blocks = var.admin_ip
    }
  ]
}

# Uptime check for website
resource "aws_route53_health_check" "healthcheck_probe" {
  fqdn              = module.ec2_instance.public_dns
  port              = 80
  type              = "HTTP"
  resource_path     = "/"
  failure_threshold = "3"
  request_interval  = "30"
  tags = {
    Name = "${var.ec2_instance_name}-uptime-check"
  }
}

# Uptime check alert for the website
module "healthcheck_alarm" {
  source              = "terraform-aws-modules/cloudwatch/aws//modules/metric-alarm"
  version             = "5.5.0"
  alarm_name          = format("%s-%s", "${var.ec2_instance_name}-Uptime-Check-Alarm", local.name_suffix)
  alarm_description   = "This metric monitors route-53-healthchecks for ${module.ec2_instance.id}"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 1
  threshold           = 1
  period              = 60
  namespace           = "AWS/Route53"
  metric_name         = "HealthCheckStatus"
  statistic           = "Minimum"
  treat_missing_data  = "breaching"
  dimensions = {
    HealthCheckId = aws_route53_health_check.healthcheck_probe.id
  }
  alarm_actions = [aws_sns_topic.alerts.arn]
}

# Alert for high CPU utilization, which will throttle burstable instances if it runs out of CPU credits
module "cpu_metric_alarm" {
  source              = "terraform-aws-modules/cloudwatch/aws//modules/metric-alarm"
  version             = "5.5.0"
  alarm_name          = format("%s-%s", "${var.ec2_instance_name}-CPU-Utilization-High-Alarm", local.name_suffix)
  alarm_description   = "This metric monitors EC2 CPU utilization for ${module.ec2_instance.id}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  threshold           = 10  # Baseline CPU utilization for t2.micro
  period              = 300 # 5 minutes with Amazon EC2 basic monitoring
  namespace           = "AWS/EC2"
  metric_name         = "CPUUtilization"
  statistic           = "Average"
  dimensions = {
    InstanceId = module.ec2_instance.id
  }
  alarm_actions = [aws_sns_topic.alerts.arn]
}
