terraform {
  backend "s3" {
    bucket         = "aws-prod-state-28-01-2026"
    key            = "vpc/prod/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}