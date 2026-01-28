# -------- COMMON --------
variable "environment" { type = string }
variable "tags" { type = map(string) }

# -------- VPC --------
variable "cidr_block" { type = string }
variable "public_subnet_cidrs" { type = list(string) }
variable "private_subnet_cidrs" { type = list(string) }
variable "availability_zones" { type = list(string) }
variable "enable_nat_gateway" { type = bool }

# -------- IAM --------
variable "s3_bucket_arns" { type = list(string) }
variable "create_ci_cd_user" { type = bool }
variable "iam_tags" { type = map(string) }

# -------- APP SG --------
variable "app_sg_name" { type = string }
variable "app_sg_description" { type = string }
variable "app_sg_ingress_rules" {
  type = list(object({
    name        = string
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
}
variable "app_sg_egress_rules" {
  type = list(object({
    name        = string
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
}
variable "app_sg_tags" { type = map(string) }

# -------- APP EC2 --------
variable "app_name" { type = string }
variable "app_instance_count" { type = number }
variable "app_ami_id" { type = string }
variable "app_instance_type" { type = string }
variable "app_associate_public_ip" { type = bool }
variable "app_instance_tags" { type = map(string) }
variable "app_root_volume_size" { type = number }
variable "app_root_volume_type" { type = string }
variable "app_encrypt_root_volume" { type = bool }
variable "app_allocate_eip" { type = bool }

# -------- DB SG --------
variable "db_sg_name" { type = string }
variable "db_sg_description" { type = string }
variable "db_sg_ingress_rules" {
  type = list(object({
    name        = string
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
}
variable "db_sg_egress_rules" {
  type = list(object({
    name        = string
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
}
variable "db_sg_tags" { type = map(string) }

# -------- DB EC2 --------
variable "db_name" { type = string }
variable "db_instance_count" { type = number }
variable "db_ami_id" { type = string }
variable "db_instance_type" { type = string }
variable "db_associate_public_ip" { type = bool }
variable "db_root_volume_size" { type = number }
variable "db_instance_tags" { type = map(string) }
variable "db_root_volume_type" { type = string }
variable "db_encrypt_root_volume" { type = bool }