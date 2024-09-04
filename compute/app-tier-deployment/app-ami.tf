resource "aws_ami_from_instance" "app_tier_ami" {
  name               = "ec2-app-ami"
  source_instance_id = aws_instance.app_tier_instance.id
  description        = "AMI for the app level EC2 instance to use for auto scaling"

  lifecycle {
    create_before_destroy = false
  }
  tags = merge(local.tags,
    {
      Name = "app-tier-instance-ami"
    }
  )
}