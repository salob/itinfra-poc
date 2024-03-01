# create the vpc

resource "aws_vpc" "vpc-main" {
  cidr_block = var.VPC_BLOCK[local.AWS_ENV]
  tags = {
    Name = "${local.AWS_ENV}-vpc"
  }
}

# create public subnet 1

resource "aws_subnet" "subnet-public1" {
  vpc_id            = aws_vpc.vpc-main.id
  cidr_block        = var.SUBNET_1_BLOCK[local.AWS_ENV]
  availability_zone = "us-east-1a"
  tags = {
    Name = "${local.AWS_ENV}-subnet-public1"
  }
}

# create private subnet 2

resource "aws_subnet" "subnet-private1" {
  vpc_id            = aws_vpc.vpc-main.id
  cidr_block        = var.SUBNET_2_BLOCK[local.AWS_ENV]
  availability_zone = "us-east-1b"
  tags = {
    Name = "${local.AWS_ENV}-subnet-private1"
  }
}

# create vpc internet gateway

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc-main.id
  tags = {
    Name = "${local.AWS_ENV}-igw"
  }
}

# create route table for public subnet

resource "aws_route_table" "rtb-public" {
  vpc_id = aws_vpc.vpc-main.id
  tags = {
    Name = "${local.AWS_ENV}-rtb-public"
  }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

# associate route table with public subnet

resource "aws_route_table_association" "subnet-public-assoc" {
  subnet_id      = aws_subnet.subnet-public1.id
  route_table_id = aws_route_table.rtb-public.id
}

# create an Elastic IP for NAT gateway

resource "aws_eip" "nat-eip" {
  domain = "vpc"
  tags = {
    Name : "${local.AWS_ENV}-ngw-eip"
  }
}

# create a NAT gateway in public subnet for private subnet

resource "aws_nat_gateway" "nat-gw" {
  allocation_id = aws_eip.nat-eip.id
  subnet_id     = aws_subnet.subnet-public1.id
  tags = {
    Name = "${local.AWS_ENV}-ngw"
  }
}

# Create a route table for private subnet
resource "aws_route_table" "rtb-private1" {
  vpc_id = aws_vpc.vpc-main.id
  tags = {
    Name = "${local.AWS_ENV}-rtb-private1"
  }
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gw.id
  }
}

# associate private subnet with the route table

resource "aws_route_table_association" "subnet-private1-assoc" {
  subnet_id      = aws_subnet.subnet-private1.id
  route_table_id = aws_route_table.rtb-private1.id
}
