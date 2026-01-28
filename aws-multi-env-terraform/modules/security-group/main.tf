resource "aws_security_group" "main" {
  name        = "${var.environment}-${var.name}"
  description = var.description
  vpc_id      = var.vpc_id

  tags = merge(
    var.tags,
    {
      Name = "${var.environment}-${var.name}"
    }
  )
}

# Ingress rules
resource "aws_vpc_security_group_ingress_rule" "ingress_rules" {
  for_each = { for idx, rule in var.ingress_rules : idx => rule }

  security_group_id = aws_security_group.main.id

  ip_protocol = each.value.protocol
  cidr_ipv4   = each.value.cidr_blocks[0]
  description = each.value.description

  from_port = each.value.protocol == "-1" ? null : each.value.from_port
  to_port   = each.value.protocol == "-1" ? null : each.value.to_port
}




# Egress rules
resource "aws_vpc_security_group_egress_rule" "egress_rules" {
  for_each = { for idx, rule in var.egress_rules : idx => rule }

  security_group_id = aws_security_group.main.id

  ip_protocol = each.value.protocol
  cidr_ipv4   = each.value.cidr_blocks[0]
  description = each.value.description

  from_port = each.value.protocol == "-1" ? null : each.value.from_port
  to_port   = each.value.protocol == "-1" ? null : each.value.to_port
}
