data "http" "my_ip" {
  url = "https://ipinfo.io/ip"
}

resource "aws_security_group" "sg_internet_facing_lb" {
  vpc_id = aws_vpc.main_vpc.id
  name = "secg-internet-facing-lb"
  ingress {
    description = "Allow HTTP traffic from my IP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${trimspace(data.http.my_ip.response_body)}/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  description = "External Load Balancer security group"
  tags        = merge(module.tags.tags, { Name = "internet-facing-lb-sg" })
}

resource "aws_security_group" "web_tier_sg" {
  vpc_id = aws_vpc.main_vpc.id
  name = "secg-web-tier"
  ingress {
    description = "Allow HTTP traffic from my IP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${trimspace(data.http.my_ip.response_body)}/32"]
  }

  ingress {
    description     = "Allow HTTP traffic from internet facing lb security group"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.sg_internet_facing_lb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  description = "SG for web tier"
  tags        = merge(module.tags.tags, { Name = "web-tier-sg" })
}

resource "aws_security_group" "internal_lb_sg" {
  vpc_id = aws_vpc.main_vpc.id
  name = "secg-internal-lb"
  ingress {
    description     = "Allow HTTP traffic from internal load balancer SG"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.web_tier_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  description = "SG for the internal load balancer"
  tags        = merge(module.tags.tags, { Name = "internal-lb-sg" })
}

resource "aws_security_group" "private_instance_sg" {
  vpc_id = aws_vpc.main_vpc.id
  name = "secg-private-instance"

  ingress {
    description     = "Allow HTTP traffic from internal lb SG"
    from_port       = 4000
    to_port         = 4000
    protocol        = "tcp"
    security_groups = [aws_security_group.internal_lb_sg.id]
  }

  ingress {
    description = "Allow HTTP traffic from my IP"
    from_port   = 4000
    to_port     = 4000
    protocol    = "tcp"
    cidr_blocks = ["${trimspace(data.http.my_ip.response_body)}/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  description = "SG for private app SG"
  tags        = merge(module.tags.tags, { Name = "private-instance-sg" })
}

resource "aws_security_group" "db_sg" {
  vpc_id      = aws_vpc.main_vpc.id
  name = "secg-db"
  description = "SG for our databases"

  tags = merge(module.tags.tags, { Name = "db-sg" })

  ingress {
    description     = "Allow HTTP traffic from my IP"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.private_instance_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}