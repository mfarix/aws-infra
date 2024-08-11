terraform {
  backend "s3" {
    bucket  = "tfstate-850624439715"
    key     = "dev/aws-infra/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}

module "dev_infra" {
  source = "../../blueprint"
  tf_env = "dev"
  region = "ap-southeast-1"
}