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
    # Update the system
    sudo apt-get update
    sudo apt-get upgrade -y
    curl -fsSL https://deb.nodesource.com/setup_21.x | sudo -E bash -
    sudo apt-get install -y nodejs
    node --version
    npm -v
    cd ~/
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    sudo apt install unzip
    unzip awscliv2.zip
    sudo ./aws/install
    aws --version
    aws s3 cp s3://${var.s3_bucket_name}/application-code/web-tier/ web-tier --recursive
    cd ~/web-tier
    npm install
    npm run build
    sudo npm install -g nginx -y
    cd /etc/nginx
    ls
    sudo rm nginx.conf
    sudo aws s3 cp s3://${var.s3_bucket_name}/nginx.conf .
    sudo service nginx restart
    chmod -R 755 /home/ec2-user
    sudo chkconfig nginx on
  EOF

  tags = merge(local.tags,
    {
      Name = "web-layer-instance"
    }
  )
}

