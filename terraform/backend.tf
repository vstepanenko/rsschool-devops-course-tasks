terraform {
  backend "s3" {
    bucket = "tf-state-aws-2025"
    key    = "terraform.tfstate"
    region = "us-east-1"
    encrypt = true
  }
}