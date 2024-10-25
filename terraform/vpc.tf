#  import the existing VPC into Terraform

resource "aws_vpc" "main" {
  # No need to define cidr_block since it's already set
  tags = {
    Name = "ThreatManagerVPC"
  }
}

# subnets 
resource "aws_subnet" "tm_subnet1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "172.31.10.0/24" 
  availability_zone = "us-east-1a"
  tags = {
    Name = "ThreatManagerSubnet1"
  }
}

resource "aws_subnet" "tm_subnet2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "172.31.11.0/24" 
  availability_zone = "us-east-1b"
  tags = {
    Name = "ThreatManagerSubnet2"
  }
}

# Security Groups
resource "aws_security_group" "tm_ecs_sg" {
  vpc_id = aws_vpc.main.id

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
    Name = "ThreatManagerSecurityGroup"
  }
}

# load balancers 

resource "aws_lb_target_group" "tm_target_group" {
  name     = "tm-target-group"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
    matcher             = "200"
  }

  tags = {
    Name = "ThreatManagerTargetGroup"
  }
}
