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
  region = "us-east-1"
  ec2_instance_type = "t2.micro"
}