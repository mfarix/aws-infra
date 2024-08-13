# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# ---------------------------------------------------------------------------------------------------------------------

variable "region" {
  type        = string
  description = "AWS Region for resources"
  # see https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html
}

variable "tf_env" {
  type        = string
  description = "Environment name"
}

# ----------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# ----------------------------------------------------------------------------------------------------------------------

variable "ec2_instance_type" {
  description = "Type of EC2 instance to start."
  type        = string
  default     = "t3.micro"
}

variable "ec2_instance_name" {
  description = "Name of EC2 instance."
  type        = string
  default     = "Web-Server"
}

variable "ec2_ami_ssm_parameter" {
  description = "SSM parameter name for the AMI ID. For Amazon Linux AMI SSM parameters see https://docs.aws.amazon.com/systems-manager/latest/userguide/parameter-store-public-parameters-ami.html"
  type        = string
  default     = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-6.1-x86_64"
}

variable "admin_ip" {
  description = "Administrator's Public IP used to SSH"
  type        = string
  default     = "172.225.180.188/32"
}
