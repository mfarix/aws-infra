data "aws_vpc" "default" {
  default = true
}

locals {
  user_data = <<-EOT
      #!/bin/bash
      yum update -y
      yum install -y httpd
      systemctl start httpd
      systemctl enable httpd
      echo "<h1>Hello World from EC2 created using Terraform</h1>" > /var/www/html/index.html
    EOT
}

module "ec2_instance" {
  source                      = "terraform-aws-modules/ec2-instance/aws"
  version                     = "5.6.1"
  name                        = format("%s-%s", var.ec2_instance_name, local.name_suffix)
  instance_type               = var.ec2_instance_type
  ami_ssm_parameter           = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-6.1-x86_64"
  vpc_security_group_ids      = [module.security_group.security_group_id]
  create_iam_instance_profile = true
  iam_role_use_name_prefix    = false
  iam_role_description        = "IAM role for EC2 instance to access S3"
  iam_role_policies = {
    AmazonS3ReadOnlyAccess = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
  }
  user_data_base64            = base64encode(local.user_data)
  user_data_replace_on_change = true
}

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
      description = "SSH-Fariz-Home"
      rule        = "ssh-tcp"
      cidr_blocks = "172.225.180.188/32" # Home internet public IP
    }
  ]
}
