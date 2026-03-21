terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Key pair for SSH access
resource "aws_key_pair" "monitoring" {
  key_name   = "${var.project_name}-key"
  public_key = file("C:/Users/ww100/.ssh/monitoring-key.pub")
}

# Security group
resource "aws_security_group" "monitoring" {
  name        = "${var.project_name}-sg"
  description = "Security group for monitoring stack"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Grafana"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Prometheus"
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Node Exporter"
    from_port   = 9100
    to_port     = 9100
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-sg"
  }
}

# EC2 instance
resource "aws_instance" "monitoring" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.monitoring.key_name
  vpc_security_group_ids = [aws_security_group.monitoring.id]

  user_data = <<-EOF
    #!/bin/bash
    apt-get update -y
    apt-get install -y docker.io docker-compose git
    systemctl start docker
    systemctl enable docker
    usermod -aG docker ubuntu
    cd /home/ubuntu
    git clone https://github.com/kaaaaash/cloud-infrastructure-monitoring.git
    cd cloud-infrastructure-monitoring/monitoring
    docker-compose up -d
  EOF

  tags = {
    Name = "${var.project_name}-server"
  }
}