resource "aws_ami_from_instance" "web_tier_ami" {
  name               = "ec2-web-ami"
  source_instance_id = var.web_tier_instance_id
  description        = "AMI for the web level EC2 instance to use for auto scaling"

  lifecycle {
    create_before_destroy = false
  }
  tags = merge(local.tags,
    {
      Name = "web-tier-instance-ami"
    }
  )
}