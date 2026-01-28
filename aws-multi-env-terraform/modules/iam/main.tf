# IAM Role for EC2 instances
resource "aws_iam_role" "ec2_instance_role" {
  name = "${var.environment}-ec2-instance-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = merge(
    var.tags,
    {
      Name = "${var.environment}-ec2-instance-role"
    }
  )
}

# IAM Instance Profile
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "${var.environment}-ec2-instance-profile"
  role = aws_iam_role.ec2_instance_role.name
}

# IAM Policies
resource "aws_iam_policy" "ec2_s3_access" {
  name        = "${var.environment}-ec2-s3-access"
  description = "Policy for EC2 to access S3"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ]
        Effect   = "Allow"
        Resource = var.s3_bucket_arns
      }
    ]
  })

  tags = merge(
    var.tags,
    {
      Name = "${var.environment}-ec2-s3-access"
    }
  )
}

resource "aws_iam_policy" "cloudwatch_agent" {
  name        = "${var.environment}-cloudwatch-agent"
  description = "Policy for CloudWatch agent"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "cloudwatch:PutMetricData",
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogStreams"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })

  tags = merge(
    var.tags,
    {
      Name = "${var.environment}-cloudwatch-agent"
    }
  )
}

# Attach policies to role
resource "aws_iam_role_policy_attachment" "ec2_s3_access" {
  role       = aws_iam_role.ec2_instance_role.name
  policy_arn = aws_iam_policy.ec2_s3_access.arn
}

resource "aws_iam_role_policy_attachment" "cloudwatch_agent" {
  role       = aws_iam_role.ec2_instance_role.name
  policy_arn = aws_iam_policy.cloudwatch_agent.arn
}

resource "aws_iam_role_policy_attachment" "ssm_managed_instance_core" {
  role       = aws_iam_role.ec2_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# IAM User for CI/CD
resource "aws_iam_user" "ci_cd_user" {
  count = var.create_ci_cd_user ? 1 : 0

  name = "${var.environment}-ci-cd-user"
  tags = merge(
    var.tags,
    {
      Name = "${var.environment}-ci-cd-user"
    }
  )
}

resource "aws_iam_access_key" "ci_cd_user" {
  count = var.create_ci_cd_user ? 1 : 0

  user = aws_iam_user.ci_cd_user[0].name
}

resource "aws_iam_user_policy" "ci_cd_deploy" {
  count = var.create_ci_cd_user ? 1 : 0

  name = "${var.environment}-ci-cd-deploy-policy"
  user = aws_iam_user.ci_cd_user[0].name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:*",
          "s3:*",
          "iam:*",
          "cloudformation:*",
          "rds:*",
          "elasticloadbalancing:*",
          "autoscaling:*"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}