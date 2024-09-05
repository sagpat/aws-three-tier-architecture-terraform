resource "aws_launch_template" "app_tier_lt" {
  name                   = "app-tier-asg-instance"
  image_id               = aws_ami_from_instance.app_tier_ami.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [var.private_instance_sg]

  iam_instance_profile {
    name = var.aws_iam_instance_profile
  }

  user_data = base64encode(<<-EOF
              #!/bin/bash
              cd ~/
              sudo apt update -y
              cd ~/app-tier
              pm2 start index.js
              pm2 list
              pm2 startup
              pm2 save
  EOF
  )
  tag_specifications {
    resource_type = "instance"
    tags = merge(local.tags,
      {
        Name = "app-tier-lt"
      }
    )
  }
}