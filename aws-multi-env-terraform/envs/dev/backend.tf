terraform {
  backend "s3" {
    bucket         = "mycompany-terraform-state-global"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-state-lock"
  }
}