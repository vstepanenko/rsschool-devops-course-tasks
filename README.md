# RSSchool AWS DevOps Course Tasks

This repo contains Terraform code to create:

- An S3 bucket for state storage
- A GitHub OIDC-connected IAM role for GitHub Actions

The workflow runs:
- terraform fmt
- terraform plan
- terraform apply

## Requirements
- Terraform
- AWS account
- Enabled GitHub Actions OIDC

## Setup
Add your `bucket_name` to `terraform.tfvars` or override with CLI.
