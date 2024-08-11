terraform {
  backend "s3" {
    bucket  = "tfstate-850624439715"
    key     = "prod/aws-infra/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}

module "prod_infra" {
  source = "../../blueprint"
  tf_env = "prod"
  region = "ap-southeast-1"
}