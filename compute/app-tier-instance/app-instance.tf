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


resource "aws_instance" "app_tier_instance" {
  ami                         = data.aws_ami.ubuntu_ami.id
  instance_type               = "t2.micro"
  subnet_id                   = var.aws_subnet_ids[local.private_app_index_az1].id
  vpc_security_group_ids      = [var.private_instance_sg]
  iam_instance_profile        = var.aws_iam_instance_profile
  monitoring                  = true
  user_data_replace_on_change = true

  root_block_device {
    delete_on_termination = true
    volume_size           = 10
    volume_type           = "gp3"
  }

  # terraform taint 'module.compute_app_tier.aws_instance.app_tier_instance'
  # Refactor (enhancement): Use AWS Secrets Manager to get the username, password and RDS writer endpoint
  user_data = <<-EOF
    #!/bin/bash

    # Update the system
    sudo apt-get update
    sudo apt-get upgrade -y

    # Install necessary dependencies
    sudo apt-get install -y wget mysql-client

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
                "log_group_name": "syslog",
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

    # MySQL commands
    mysql -h ${var.rds_writer_endpoint} -u admin -pyuYBuFGSKLVG --enable-cleartext-plugin <<SQL
        CREATE DATABASE IF NOT EXISTS webappdb_data1;
        SHOW DATABASES;
        USE webappdb_data1;
        CREATE TABLE IF NOT EXISTS transactions(
          id INT NOT NULL AUTO_INCREMENT,
          amount DECIMAL(10,2),
          description VARCHAR(100),
          PRIMARY KEY(id)
        );
        INSERT INTO transactions (amount,description) VALUES (50,'Grandios');
        SELECT * FROM transactions;
    SQL
    # Install Node.js using NodeSource
    curl -fsSL https://deb.nodesource.com/setup_21.x | sudo -E bash -
    sudo apt-get install -y nodejs
    node --version
    npm -v
    sudo npm install -g pm2
    cd ~/
    sudo apt update
    sudo apt install awscli -y
    aws s3 cp s3://${var.s3_bucket_name}/application-code/app-tier/ app-tier --recursive
    cd ~/app-tier
    npm install
    pm2 start index.js
    pm2 list
    pm2 startup
    pm2 save
  EOF

  tags = merge(local.tags,
    {
      Name = "app-layer-instance"
    }
  )
}
