resource "aws_security_group" "vpn" {
  name_prefix = "${var.prefix}-vpn-"
  description = "Allow connectivity to and from the WireGuard VPN instance."
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "vpn_access" {
  type                     = "ingress"
  from_port                = var.wireguard_vpn_port
  to_port                  = var.wireguard_vpn_port
  protocol                 = "udp"
  cidr_blocks              = var.vpn_access_cidrs
  security_group_id        = aws_security_group.vpn.id
}

resource "aws_security_group_rule" "management_access_80" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  cidr_blocks              = var.management_access_cidrs
  security_group_id        = aws_security_group.vpn.id
}

resource "aws_security_group_rule" "management_access_8000" {
  type                     = "ingress"
  from_port                = 8000
  to_port                  = 8000
  protocol                 = "tcp"
  cidr_blocks              = var.management_access_cidrs
  security_group_id        = aws_security_group.vpn.id
}

resource "aws_security_group_rule" "management_access_443" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  cidr_blocks              = var.management_access_cidrs
  security_group_id        = aws_security_group.vpn.id
}

resource "aws_security_group_rule" "management_access_22" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  cidr_blocks              = var.management_access_cidrs
  security_group_id        = aws_security_group.vpn.id
}

resource "aws_security_group_rule" "vpn_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.vpn.id
}

resource "aws_eip" "vpn" {
  vpc = true
}
