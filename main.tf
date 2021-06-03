terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.12.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer"
  public_key = file("deployer.pub")
}

resource "aws_security_group" "builder" {
  name        = "builder_security_group"
  description = "Allow SSH inbound traffic"

  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
   egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "prod" {
  name        = "prod_security_group"
  description = "Allow SSH inbound traffic"

  dynamic "ingress" {
    for_each = [22, 5080, 9999, 1935]
    content{
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

   egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "builder" {
  count         = var.builder_instance_count
  ami           = lookup(var.ami,var.aws_region)
  instance_type = var.instance_type
  key_name      = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.builder.id]
  user_data     = <<EOF
#!/bin/bash
sudo apt update \
&& sudo apt install -y python3
EOF

  tags = {
    Name  = "builder"
  }
}

resource "aws_instance" "prod" {
  count         = var.prod_instance_count
  ami           = lookup(var.ami,var.aws_region)
  instance_type = var.instance_type
  key_name      = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.prod.id]
  user_data     = <<EOF
#!/bin/bash
sudo apt update \
&& sudo apt install -y python3
EOF

  tags = {
    Name  = "prod"
  }
}
resource "aws_ecr_repository" "deployer" {
  name                 = var.app_name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
