data "aws_ami" "amazon_linux_2_ssm" {
  most_recent = true

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
}

resource "aws_instance" "web_tier_instance" {
  ami                         = data.aws_ami.amazon_linux_2_ssm.id
  instance_type               = "t2.micro"
  subnet_id                   = var.aws_subnet_ids[local.public_web_index_az1].id
  vpc_security_group_ids      = [var.web_tier_sg]
  iam_instance_profile        = var.aws_iam_instance_profile
  monitoring                  = true
  associate_public_ip_address = true
  root_block_device {
    delete_on_termination = true
    volume_size           = 10
    volume_type           = "gp3"
  }

  # terraform taint 'module.compute_app_tier.aws_instance.app_tier_instance'

  user_data = <<-EOF
    #!/bin/bash
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
    source ~/.bashrc
    nvm install 16
    nvm use 16
    cd ~/
    aws s3 cp s3://${var.s3_bucket_name}/web-tier/ web-tier --recursive
    cd ~/web-tier
    npm install 
    npm run build
    sudo yum install nginx -y
    cd /etc/nginx
    ls
    sudo rm nginx.conf
    sudo aws s3 cp s3://${var.s3_bucket_name}/nginx.conf .
    sudo service nginx restart
    chmod -R 755 /home/ec2-user
    sudo chkconfig nginx on
  EOF

  # aws s3 cp s3://three-tier-app-XXXX/application-code/app-tier/ app-tier --recursive
  # aws s3 cp s3://three-tier-app-XXX/application-code/web-tier/ web-tier --recursive
  # sudo aws s3 cp s3://three-tier-app-XXXX/application-code/web-tier/nginx.conf .
  # sudo yum install nginx -y

  tags = merge(local.tags,
    {
      Name = "web-layer-instance"
    }
  )
}

