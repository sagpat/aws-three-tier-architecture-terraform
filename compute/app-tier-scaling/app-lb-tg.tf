# app tier target group
resource "aws_lb_target_group" "app_tier_tg" {
  name             = "app-tier-tg"
  port             = 4000
  protocol         = "HTTP"
  vpc_id           = var.aws_vpc_id
  target_type      = "instance"
  protocol_version = "HTTP1"

  health_check {
    path     = "/health"
    port     = 4000
    protocol = "HTTP"
  }
}

# app tier load balancer
resource "aws_lb" "app_tier_alb" {
  name               = "app-tier-internal-alb"
  load_balancer_type = "application"
  internal           = true
  security_groups    = [var.internal_lb_sg]
  subnets            = local.app_subet_ids
  ip_address_type    = "ipv4"
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app_tier_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tier_tg.arn
  }
}