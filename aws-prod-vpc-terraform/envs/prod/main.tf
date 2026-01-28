module "vpc" {
  source = "../../modules/vpc"

  project     = var.project
  environment = var.environment
  cidr_block  = "10.0.0.0/16"

  azs = ["ap-south-1a", "ap-south-1b"]

  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.11.0/24", "10.0.12.0/24"]
  db_subnets      = ["10.0.21.0/24", "10.0.22.0/24"]

  tags = local.common_tags
}
