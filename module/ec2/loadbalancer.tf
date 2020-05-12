###############################################
# Network Load Balancer (internet facing)
################################################


locals {
  private_subnets = [for r in var.private_subnets : r]
  public_subnets  = [for r in var.public_subnets : r]
}

# Find a certificate that is issued
data "aws_acm_certificate" "alb" {
  domain   = "www.${var.domain_name}"
  statuses = ["ISSUED"]
}


resource "aws_lb" "alb" {
  name               = "${var.name}-ALB"
  load_balancer_type = "application"
  internal           = false
  security_groups    = [aws_security_group.webserver_sg.id]

  dynamic "subnet_mapping" {
    for_each = range(length(local.public_subnets))

    content {
      subnet_id = local.public_subnets[subnet_mapping.key]
    }
  }
  tags = merge(
    {
      "Name" = format("%s%s", var.name, "NLB")
    },
    var.tags,
  )
}


resource "aws_lb_target_group" "alb_tg" {
  name     = "${var.name}-ALB-TG"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

resource "aws_lb_listener" "forward_http_to_https" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = data.aws_acm_certificate.alb.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_tg.arn
  }
}