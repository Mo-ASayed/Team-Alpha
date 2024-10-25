provider "aws" {
  region = "eu-west-2"
}

resource "aws_vpc" "tm_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "tm_vpc"
    Project = "threat-model"
  }
}

resource "aws_subnet" "tm_subnet_1" {
  vpc_id            = aws_vpc.tm_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "eu-west-2a"
  tags = {
    Name = "tm_subnet_1"
    Project = "threat-model"
  }
}

resource "aws_subnet" "tm_subnet_2" {
  vpc_id            = aws_vpc.tm_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "eu-west-2b"
  tags = {
    Name = "tm_subnet_2"
    Project = "threat-model"
  }
}

resource "aws_internet_gateway" "tm_igw" {
  vpc_id = aws_vpc.tm_vpc.id
  tags = {
    Name = "tm_igw"
    Project = "threat-model"
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
    Project = "threat-model"
  }
}

resource "aws_route_table_association" "tm_rta_1" {
  subnet_id      = aws_subnet.tm_subnet_1.id
  route_table_id = aws_route_table.tm_route_table.id
}

resource "aws_route_table_association" "tm_rta_2" {
  subnet_id      = aws_subnet.tm_subnet_2.id
  route_table_id = aws_route_table.tm_route_table.id
}

resource "aws_security_group" "tm_sg" {
  name        = "tm_security_group"
  description = "Security group for threat model application"
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
  
