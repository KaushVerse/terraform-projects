variable "environment" {
  description = "Environment name"
  type        = string
}

variable "s3_bucket_arns" {
  description = "List of S3 bucket ARNs for EC2 access"
  type        = list(string)
  default     = ["arn:aws:s3:::mycompany-*"]
}

variable "create_ci_cd_user" {
  description = "Create CI/CD IAM user"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Additional tags"
  type        = map(string)
  default     = {}
}