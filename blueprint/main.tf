module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.6.1"
  name    = format("%s-%s", var.ec2_instance_name, local.name_suffix)
  instance_type     = var.ec2_instance_type
  ami_ssm_parameter = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-6.1-x86_64"
}
