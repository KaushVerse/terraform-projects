resource "aws_instance" "main" {
  count = var.instance_count

  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = var.security_group_ids
  associate_public_ip_address = var.associate_public_ip
  key_name                    = null
  iam_instance_profile        = var.iam_instance_profile_name
   


  root_block_device {
    volume_size = var.root_volume_size
    volume_type = var.root_volume_type
    encrypted   = var.encrypt_root_volume
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.environment}-${var.name}-${count.index + 1}"
    }
  )

  lifecycle {
    ignore_changes = [ami]
  }
}

resource "aws_eip" "instance" {
  count = var.allocate_elastic_ip ? var.instance_count : 0

  instance = aws_instance.main[count.index].id
  domain   = "vpc"

  tags = merge(
    var.tags,
    {
      Name = "${var.environment}-${var.name}-eip-${count.index + 1}"
    }
  )
}
