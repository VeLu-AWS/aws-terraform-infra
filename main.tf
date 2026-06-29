terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.3.0"
}

provider "aws" {
  region = var.aws_region
}

# ─── EC2 Instance ───────────────────────────────────────────────
resource "aws_instance" "railman_server" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.railman_sg.id]
  subnet_id              = var.subnet_id

  root_block_device {
    volume_type = "gp3"
    volume_size = 30
    encrypted   = true
  }

  user_data = <<-EOF
    #!/bin/bash
    apt-get update -y
    apt-get install -y nginx
    systemctl start nginx
    systemctl enable nginx
    echo "<h1>Railman Server - Deployed via Terraform</h1>" \
      > /var/www/html/index.html
  EOF

  tags = {
    Name        = "railman-server"
    Project     = "indian-railways"
    Environment = "production"
    ManagedBy   = "terraform"
  }
}

# ─── Elastic IP ─────────────────────────────────────────────────
resource "aws_eip" "railman_eip" {
  instance = aws_instance.railman_server.id
  domain   = "vpc"

  tags = {
    Name    = "railman-eip"
    Project = "indian-railways"
  }
}

# ─── S3 Bucket ──────────────────────────────────────────────────
resource "aws_s3_bucket" "railway_data" {
  bucket = var.s3_bucket_name

  tags = {
    Name        = "railway-data-bucket"
    Project     = "indian-railways"
    Environment = "production"
    ManagedBy   = "terraform"
  }
}

resource "aws_s3_bucket_versioning" "railway_data_versioning" {
  bucket = aws_s3_bucket.railway_data.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "railway_data_lifecycle" {
  bucket = aws_s3_bucket.railway_data.id

  rule {
    id     = "glacier-archival"
    status = "Enabled"

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = 90
      storage_class = "GLACIER"
    }
  }
}

# ─── Security Group ─────────────────────────────────────────────
resource "aws_security_group" "railman_sg" {
  name        = "railman-security-group"
  description = "Security group for Railman railway server"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "OpenVPN"
    from_port   = 1194
    to_port     = 1194
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "railman-sg"
    Project = "indian-railways"
  }
}
