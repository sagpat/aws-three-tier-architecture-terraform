# app tier target group
resource "aws_lb_target_group" "web_tier_tg" {
  name             = "web-tier-tg"
  port             = 80
  protocol         = "HTTP"
  vpc_id           = var.aws_vpc_id
  target_type      = "instance"
  protocol_version = "HTTP1"

  health_check {
    path     = "/health"
    port     = 80
    protocol = "HTTP"
  }
}

# app tier load balancer
resource "aws_lb" "web_tier_alb" {
  name               = "web-tier-internal-alb"
  load_balancer_type = "application"
  security_groups    = [var.internet_lb_sg]
  subnets            = local.web_subet_ids
  ip_address_type    = "ipv4"
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.web_tier_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_tier_tg.arn
  }
}