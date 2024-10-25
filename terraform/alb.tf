resource "aws_lb" "tm_lb" {
  name               = "tm-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.tm_sg.id]
  subnets            = [aws_subnet.tm_subnet_1.id, aws_subnet.tm_subnet_2.id]

  enable_deletion_protection = true

  tags = {
    Name = "threat model"
  }
}

resource "aws_lb_target_group" "tm_tg" {
  name     = "tm-tg-tf"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.tm_vpc.id
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.tm_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      protocol    = "HTTPS"
      port        = "443"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "https_listener" {
  load_balancer_arn = aws_lb.tm_lb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.my_cert.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tm_tg.arn
  }
}