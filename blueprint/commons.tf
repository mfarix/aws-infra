resource "random_string" "launch_id" {
  length  = 4
  special = false
  upper   = false
}

locals {
  name_suffix = format("%s-%s", var.tf_env, random_string.launch_id.result)
}

data "aws_caller_identity" "current" {}

data "aws_vpc" "default" {
  default = true
}

resource "aws_sns_topic" "alerts" {
  name = "cloudwatch-alerts"
}
