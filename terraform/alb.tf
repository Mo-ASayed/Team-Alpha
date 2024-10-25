# application load balancer

# 1. Define load balancer

resource "aws_lb" "tm_lb" {
  name               = "tm-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.tm_sg.id]
  subnets            = [faws_subnet.tm_subnet_1.id, aws_subnet.tm_subnet_2.id]

  enable_deletion_protection = true

  tags = {
    Name = "threat model"
  }
}


# 2. Create Target groups - A target group is required to register your EC2 instances or other 
# resources that the ALB will forward traffic to.

resource "aws_lb_target_group" "tm_tg" {
  name     = "tm-tg-tf"
  port     = 80                        

  protocol = "HTTP"
  vpc_id   = aws_vpc.tm_vpc.id             # The VPC where your ALB and EC2 are running. if name is not main, add name

}


# 3. Set listeners - A listener defines how the ALB forwards traffic (e.g., HTTP/HTTPS). 
# You'll need at least one listener, usually for HTTP (port 80) or HTTPS (port 443)

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.tm_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    
    redirect {
      protocol = "HTTPS"
      port     = "443"
      status_code = "HTTP_301"
    }
  }
}

# 4. HTTPs listeners - 


resource "aws_lb_listener" "https_listener" {
  load_balancer_arn = aws_lb.tm_lb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"  # AWS recommended SSL policy
  certificate_arn   = aws_acm_certificate.my_cert.arn  # ARN of your SSL certificate

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tm_tg.arn  # Forward traffic to the target group
  }
}
