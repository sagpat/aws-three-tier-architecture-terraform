resource "aws_autoscaling_group" "app_tier_asg" {
  name = "app-tier-asg"
  launch_template {
    id = aws_launch_template.app_tier_lt.id
    version = "$Latest"
  }

  vpc_zone_identifier = local.app_subet_ids
  target_group_arns = [aws_lb_target_group.app_tier_tg.arn]

  desired_capacity    = 2
  min_size            = 2
  max_size            = 2
}