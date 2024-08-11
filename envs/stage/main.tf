terraform {
  backend "s3" {
    bucket  = "tfstate-850624439715"
    key     = "stage/aws-infra/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}

module "stage_infra" {
  source = "../../blueprint"
  tf_env = "stage"
  region = "ap-southeast-1"
}