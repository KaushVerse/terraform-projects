############################################
# 🌐 NETWORK LAYER (VPC, Subnets, NAT, IGW)
############################################
module "vpc" {
  source = "../../modules/vpc"

  environment = var.environment
  cidr_block  = var.cidr_block

  # 🌍 Subnets
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs

  # 📍 AZs & NAT
  availability_zones = var.availability_zones
  enable_nat_gateway = var.enable_nat_gateway

  # 🏷️ Common tags
  tags = var.tags
}

############################################
# 🔐 IAM LAYER (Roles, Policies, Users)
############################################
module "iam" {
  source = "../../modules/iam"

  environment       = var.environment
  s3_bucket_arns    = var.s3_bucket_arns
  create_ci_cd_user = var.create_ci_cd_user

  tags = var.iam_tags
}

############################################
# 🛡️ APP SECURITY GROUP
# Public-facing rules (HTTP / HTTPS / SSH)
############################################
module "app_security_group" {
  source = "../../modules/security-group"

  name        = var.app_sg_name
  description = var.app_sg_description
  vpc_id      = module.vpc.vpc_id
  environment = var.environment

  # 🚪 Ingress & Egress rules
  ingress_rules = var.app_sg_ingress_rules
  egress_rules  = var.app_sg_egress_rules

  tags = var.app_sg_tags
}

############################################
# 🚀 APPLICATION EC2 INSTANCES
# Public subnet (internet-facing)
############################################
module "app_instances" {
  source = "../../modules/ec2"

  name                      = var.app_name
  environment               = var.environment
  instance_count            = var.app_instance_count
  ami_id                    = var.app_ami_id
  instance_type             = var.app_instance_type

  # 🌐 Public subnet
  subnet_id          = module.vpc.public_subnet_ids[0]
  security_group_ids = [module.app_security_group.security_group_id]

  # 🔐 IAM profile (SSM, CloudWatch, S3 access)
  iam_instance_profile_name = module.iam.ec2_instance_profile_name

  # 🌍 Networking
  associate_public_ip = var.app_associate_public_ip
  allocate_elastic_ip = var.app_allocate_eip

  # 💾 Root volume
  root_volume_size    = var.app_root_volume_size
  root_volume_type    = var.app_root_volume_type
  encrypt_root_volume = var.app_encrypt_root_volume

  # 🏷️ Tags
  tags = var.app_instance_tags
}

############################################
# 🛡️ DATABASE SECURITY GROUP
# Only App → DB access (MySQL)
############################################
module "db_security_group" {
  source = "../../modules/security-group"

  name        = var.db_sg_name
  description = var.db_sg_description
  vpc_id      = module.vpc.vpc_id
  environment = var.environment

  # 🔒 DB access rules
  ingress_rules = var.db_sg_ingress_rules
  egress_rules  = var.db_sg_egress_rules

  tags = var.db_sg_tags
}

############################################
# 🗄️ DATABASE EC2 INSTANCE
# Private subnet (no public access)
############################################
module "db_instance" {
  source = "../../modules/ec2"

  name                      = var.db_name
  environment               = var.environment
  instance_count            = var.db_instance_count
  ami_id                    = var.db_ami_id
  instance_type             = var.db_instance_type

  # 🔒 Private subnet
  subnet_id          = module.vpc.private_subnet_ids[0]
  security_group_ids = [module.db_security_group.security_group_id]

  # 🔐 IAM profile
  iam_instance_profile_name = module.iam.ec2_instance_profile_name

  # 🚫 No public access
  associate_public_ip = false
  allocate_elastic_ip = false

  # 💾 Root volume
  root_volume_size    = var.db_root_volume_size
  root_volume_type    = var.db_root_volume_type
  encrypt_root_volume = var.db_encrypt_root_volume

  # 🏷️ Tags
  tags = var.db_instance_tags
}
