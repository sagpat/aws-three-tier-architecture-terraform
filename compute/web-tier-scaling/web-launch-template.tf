resource "aws_launch_template" "web_tier_lt" {
  name                   = "web-tier-asg-instance"
  image_id               = aws_ami_from_instance.web_tier_ami.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [var.web_tier_sg]

  iam_instance_profile {
    name = var.aws_iam_instance_profile
  }

    user_data = base64encode(<<-EOF
        cd /etc/nginx
        ls
        sudo service nginx restart
        sudo chmod -R 755 /home/ubuntu
        sudo systemctl enable nginx
    EOF
    )


  tag_specifications {
    resource_type = "instance"
    tags = merge(local.tags,
      {
        Name = "web-tier-lt"
      }
    )
  }
}