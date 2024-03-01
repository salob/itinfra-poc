# create security group for vpn client endpoint
resource "aws_security_group" "vpn-client-sg" {
  name        = "${local.AWS_ENV}-vpn-client-sg"
  description = "Security Group for ${local.AWS_ENV}-vpn-client"
  vpc_id      = aws_vpc.vpc-main.id
  tags = {
    Name = "${local.AWS_ENV}-vpn-client-sg"
  }
}

# allow ssh through vpn
resource "aws_vpc_security_group_ingress_rule" "vpn-ssh" {
  security_group_id = aws_security_group.vpn-client-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

# default egress rule
resource "aws_vpc_security_group_egress_rule" "vpn-default-egress" {
  security_group_id = aws_security_group.vpn-client-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

# create security group for ec2 instances
resource "aws_security_group" "ec2-instance-sg" {
  name        = "${local.AWS_ENV}-ec2-instance-sg"
  description = "Security Group for ${local.AWS_ENV}-ec2-instances"
  vpc_id      = aws_vpc.vpc-main.id
  tags = {
    Name = "${local.AWS_ENV}-ec2-instance-sg"
  }
}

# allow https traffic in
resource "aws_vpc_security_group_ingress_rule" "instance-http" {
  security_group_id = aws_security_group.ec2-instance-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_ingress_rule" "instance-https" {
  security_group_id = aws_security_group.ec2-instance-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

# allow ssh through vpn only
resource "aws_vpc_security_group_ingress_rule" "instance-ssh" {
  security_group_id = aws_security_group.ec2-instance-sg.id
  #cidr_ipv4                    = aws_ec2_client_vpn_endpoint.vpc-main-vpn.client_cidr_block
  referenced_security_group_id = aws_security_group.vpn-client-sg.id
  from_port                    = 22
  ip_protocol                  = "tcp"
  to_port                      = 22
}

# default egress rule
resource "aws_vpc_security_group_egress_rule" "instance-default-egress" {
  security_group_id = aws_security_group.ec2-instance-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}
