# AWS Infrastructure with Terraform

This repository contains code to create and manage AWS infrastructure using Terraform. It serves as a template to quickly set up and deploy cloud resources in a structured and efficient manner.

## Table of Contents

- [Introduction](#introduction)
- [Prerequisites](#prerequisites)
- [Project Structure](#project-structure)
- [Getting Started](#getting-started)

## Introduction

This repository provides Terraform configurations to set up various AWS infrastructure components such as VPCs, subnets, security groups, EC2 instances, S3 buckets, and more. The goal is to automate the provisioning of AWS resources following best practices for security, scalability, and maintainability.

## Prerequisites

Before you begin, ensure you have met the following requirements:

- An AWS account with appropriate permissions to create and manage resources.
- Install the latest version of [AWS Command Line Interface (AWS CLI)](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html).
- Install [Terraform](https://developer.hashicorp.com/terraform/install) version `1.5.7`.

## Project Structure

The project structure follows a modular design to ensure reusability and manageability of Terraform code.

```
.
├── blueprint
│   ├── commons.tf
│   ├── ec2-user-data.sh
│   ├── main.tf
│   ├── output.tf
│   ├── providers.tf
│   └── variables.tf
├── envs
│   ├── dev
│   │   ├── main.tf
│   ├── prod
│   │   ├── main.tf
│   └── stage
│       └── main.tf
└── README.md
```
- The [blueprint/main.tf](blueprint/main.tf) file is the core component that does below:
  - It creates an Amazon EC2 bucket to store the state file. We configure bucket ACL, bucket versioning and encryption so that the state file is secure. 
  - It creates an Amazon EC2 security group table which will be used to lock the state file. 
  - It creates two Amazon CloudWatch alarms, one for checking uptime of the web application server and another to monitor CPU utilization of the EC2 instance.
- The [blueprint/commons.tf](blueprint/commons.tf) file contains the shared resources. 
- The [blueprint/ec2-user-data.sh](blueprint/ec2-user-data.sh) file is the shell script that is used to bootstrap the EC2 instance and setup Apache HTTP Server.
- The [`envs/{ENV}/main.tf`](envs) contains environment specific configurations. It creates a module which encompasses of all everything under `blueprint` folder and variables can be overridden. This is where you will run your `terraform` commands.

## Getting Started

To get a local copy up and running, follow these simple steps:

1. Configure your AWS credentials. You need an AWS access key ID and secret access key to configure AWS CLI. To learn more about configuring the AWS CLI, follow these [instructions](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html).
   ```sh
   aws configure
   ```

1. Create a S3 bucket to store terraform state files.
   ```sh
   aws s3api create-bucket --region us-east-1 --bucket tfstate-sample-bucket
   ```
   
1. Clone the repo and open it in your favourite code editor.
   ```sh
   git clone https://github.com/mfarix/aws-infra.git
   cd aws-infra
   ```

1. Update the `envs/{ENV}/main.tf` file with your desired configurations.
   1. Use AWS `us-east-1` region for best compatibility (Route 53 health checks work in Global us-east-1 region).
   2. Update the value of terraform backend bucket with the bucket created in above step.

1. Change directory to your desired environment `envs/{ENV}`. For example dev env.
   ```sh
   cd envs/dev
   ```

1. Initialize Terraform
   ```sh
   terraform init
   ```

1. Plan the deployment
   ```sh
   terraform plan
   ```

1. Apply the configuration
   ```sh
   terraform apply
   ```

---

Happy Terraforming!
