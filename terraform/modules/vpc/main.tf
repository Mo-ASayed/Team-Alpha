# vpc main.tf

resource "aws_vpc" "tm_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "tm_subnet" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.tm_vpc.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true
  tags = {
    Name = "tm_public_subnet_${count.index + 1}"
  }
}

resource "aws_subnet" "tm_private_subnet" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.tm_vpc.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = element(var.availability_zones, count.index)
  tags = {
    Name = "tm_private_subnet_${count.index + 1}"
  }
}

resource "aws_internet_gateway" "tm_igw" {
  vpc_id = aws_vpc.tm_vpc.id
  tags = {
    Name = "tm_internet_gateway"
  }
}

resource "aws_route_table" "tm_route_table" {
  vpc_id = aws_vpc.tm_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tm_igw.id
  }

  tags = {
    Name = "tm_route_table"
  }
}

resource "aws_route_table_association" "tm_rta" {
  count          = length(aws_subnet.tm_subnet)
  subnet_id      = aws_subnet.tm_subnet[count.index].id
  route_table_id = aws_route_table.tm_route_table.id
}

resource "aws_security_group" "tm_sg" {
  name        = var.sg_name
  description = "Security group for threat model"
  vpc_id      = aws_vpc.tm_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "tm_security_group"
  }
}
