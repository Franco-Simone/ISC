resource "aws_vpc" "vpc-eac" {
  cidr_block           = "172.16.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "VPC_EAC_Terraform"
  }
}

resource "aws_subnet" "private-subnet-eac" {
  vpc_id                  = aws_vpc.vpc-eac.id
  cidr_block              = "172.16.1.0/24"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "Subnet_EAC_Terraform"
  }
}

resource "aws_internet_gateway" "gw-eac" {
  vpc_id = aws_vpc.vpc-eac.id

  tags = {
    Name = "igw_EAC_Terraform"
  }
}

resource "aws_default_route_table" "eac-rt" {
  default_route_table_id = aws_vpc.vpc-eac.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw-eac.id
  }

  tags = {
    Name = "EAC_default_table"
  }
}

resource "aws_security_group" "sg-eac" {
  name        = "eac-sg"
  description = "Allow all inbound and outbound traffic"
  vpc_id      = aws_vpc.vpc-eac.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "EAC-sg"
  }
}