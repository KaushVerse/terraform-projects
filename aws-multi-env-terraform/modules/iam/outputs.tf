output "ec2_instance_profile_name" {
  description = "EC2 instance profile name"
  value       = aws_iam_instance_profile.ec2_instance_profile.name
}

output "ec2_instance_profile_arn" {
  description = "EC2 instance profile ARN"
  value       = aws_iam_instance_profile.ec2_instance_profile.arn
}

output "ci_cd_user_access_key" {
  description = "CI/CD user access key (sensitive)"
  value       = var.create_ci_cd_user ? aws_iam_access_key.ci_cd_user[0].id : null
  sensitive   = true
}

output "ci_cd_user_secret_key" {
  description = "CI/CD user secret key (sensitive)"
  value       = var.create_ci_cd_user ? aws_iam_access_key.ci_cd_user[0].secret : null
  sensitive   = true
}