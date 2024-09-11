data "aws_ami" "ubuntu_ami" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-*-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  owners = ["099720109477"]
}

resource "aws_instance" "web_tier_instance" {
  ami                         = data.aws_ami.ubuntu_ami.id
  instance_type               = "t2.medium"
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

    # Update the system
    sudo apt-get update
    sudo apt-get upgrade -y

    # Download the CloudWatch agent
    sudo wget https://s3.amazonaws.com/amazoncloudwatch-agent/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb

    # Install the CloudWatch agent
    sudo dpkg -i -E ./amazon-cloudwatch-agent.deb

    # Create a configuration file
    sudo mkdir -p /opt/aws/amazon-cloudwatch-agent/etc
    sudo bash -c 'cat > /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json <<EOF
    {
      "agent": {
        "run_as_user": "root"
      },
      "logs": {
        "logs_collected": {
          "files": {
            "collect_list": [
              {
                "file_path": "/var/log/syslog",
                "log_group_name": "syslog_web",
                "log_stream_name": "{instance_id}"
              }
            ]
          }
        }
      }
    }
    EOF'

    # Start the CloudWatch agent
    sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json
    
    whoami
    sudo su - ubuntu
    pwd
    curl -fsSL https://deb.nodesource.com/setup_21.x | sudo -E bash -
    sudo apt-get install -y nodejs
    node --version
    npm -v
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    sudo apt install unzip
    unzip awscliv2.zip
    sudo ./aws/install
    aws --version
    aws s3 cp s3://${var.s3_bucket_name}/application-code/web-tier/ web-tier --recursive
    cd /web-tier
    npm install
    npm run build
    sudo apt install nginx -y
    cd /etc/nginx
    ls
    sudo rm nginx.conf
    sudo aws s3 cp s3://${var.s3_bucket_name}/application-code/web-tier/nginx.conf .
    sudo service nginx restart
    sudo chmod -R 755 /home/ubuntu
    sudo systemctl enable nginx
  EOF

  tags = merge(local.tags,
    {
      Name = "web-layer-instance"
    }
  )
}

