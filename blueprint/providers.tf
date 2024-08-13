terraform {
  required_version = "1.5.7" # 1.5.7 is the latest terraform version with Mozilla Public License
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.62.0" # see https://github.com/hashicorp/terraform-provider-aws/releases
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.2" # see https://github.com/hashicorp/terraform-provider-random/releases
    }
  }
}

provider "aws" {
  region = var.region
  default_tags {
    tags = {
      Terraform   = "true"
      Environment = var.tf_env
    }
  }
}
