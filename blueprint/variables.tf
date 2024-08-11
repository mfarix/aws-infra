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
  default     = "test"
}

variable "ec2_vpc_security_group_ids" {
  description = "A list of security group IDs to associate with."
  type        = list(string)
  default     = []
}
