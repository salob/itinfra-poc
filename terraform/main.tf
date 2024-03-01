resource "aws_instance" "webserver" {
  ami                         = lookup(var.AMI, var.REGION[local.AWS_ENV])
  instance_type               = var.INSTANCE_TYPE
  key_name                    = var.KEY_NAME
  subnet_id                   = aws_subnet.subnet-public1.id
  associate_public_ip_address = true
  tags = {
    Name = "${local.AWS_ENV}-webserver"
  }
  vpc_security_group_ids = [aws_security_group.ec2-instance-sg.id]

}

output "publicIP-public-ec2-instance" {
  value = aws_instance.webserver.public_ip
}

output "privateIP-public-ec2-instance" {
  value = aws_instance.webserver.private_ip
}

resource "aws_instance" "builder" {
  ami           = lookup(var.AMI, var.REGION[local.AWS_ENV])
  instance_type = var.INSTANCE_TYPE
  key_name      = var.KEY_NAME
  subnet_id     = aws_subnet.subnet-private1.id
  tags = {
    Name = "${local.AWS_ENV}-builder"
  }
  vpc_security_group_ids = [aws_security_group.ec2-instance-sg.id]
}

output "privateIP-private-ec2-instance" {
  value = aws_instance.builder.private_ip
}
