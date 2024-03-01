# upload existing cert for vpn authentication

resource "aws_acm_certificate" "vpn-cert" {
  private_key       = file("certs/server.key")
  certificate_body  = file("certs/server.crt")
  certificate_chain = file("certs/ca.crt")
  tags = {
    Name = "VPN-Cert"
  }
}

output "imported-cert-arn" {
  value = aws_acm_certificate.vpn-cert.arn
}

# set up vpn to access ec2 instances

resource "aws_ec2_client_vpn_endpoint" "vpc-main-vpn" {
  description            = "VPN for ${local.AWS_ENV}-vpc-main"
  server_certificate_arn = aws_acm_certificate.vpn-cert.arn
  client_cidr_block      = var.VPC_CIDR[local.AWS_ENV]
  security_group_ids     = [aws_security_group.vpn-client-sg.id]
  vpc_id                 = aws_vpc.vpc-main.id
  tags = {
    Name = "${local.AWS_ENV}-client-vpn-endpoint"
  }
  split_tunnel = true
  authentication_options {
    type = "certificate-authentication"
    #root_certificate_chain_arn = var.ACM_CLIENT_CERT_ARN
    root_certificate_chain_arn = aws_acm_certificate.vpn-cert.arn
  }
  # setting to false as no cloudfront logging set up
  connection_log_options {
    enabled = false
  }
}

# obtain ec2 client vpn endpoint hostname for client vpn configuration

output "ec2-cvpn-endpoint-hostname" {
  value = aws_ec2_client_vpn_endpoint.vpc-main-vpn.dns_name
}
# associate vpn with public subnet

resource "aws_ec2_client_vpn_network_association" "vpc-subnet-public1" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.vpc-main-vpn.id
  subnet_id              = aws_subnet.subnet-public1.id
}

# associate vpn with private subnet

resource "aws_ec2_client_vpn_network_association" "vpc-subnet-private1" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.vpc-main-vpn.id
  subnet_id              = aws_subnet.subnet-private1.id
}

# allow access to public subnet

resource "aws_ec2_client_vpn_authorization_rule" "vpn-subnet-public1-auth-access" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.vpc-main-vpn.id
  target_network_cidr    = aws_subnet.subnet-public1.cidr_block
  authorize_all_groups   = true
  description            = "authorize access to vpc"
}

# allow access to private subnet

resource "aws_ec2_client_vpn_authorization_rule" "vpn-subnet-private1-auth-access" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.vpc-main-vpn.id
  target_network_cidr    = aws_subnet.subnet-private1.cidr_block
  authorize_all_groups   = true
  description            = "authorize access to vpc"
}
