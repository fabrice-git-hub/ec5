terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.95.0" # version du provider AWS terraform
    }
    vault = {
      source  = "hashicorp/vault"
      version = "4.7.0" # version du provider VAULT terraform
    }
  }
  required_version = "1.11.4" # version du binaire terraform en local
}


provider "aws" {
  region     = "us-east-1" # déclaration de la région
}

# 1. VPC
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "main_vpc"
  }
}

# 2. Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "main_igw"
  }
}

# 3. Subnet public
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a" # adapte selon ta région
  tags = {
    Name = "public_subnet"
  }
}

# 4. Table de routage
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "public_rt"
  }
}

# 5. Association de la route avec le subnet
resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# 6. Security group (SSH_HTTP)
resource "aws_security_group" "ssh_http" {
  name        = "allow_ssh_http"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # à restreindre à ton IP en prod
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # à restreindre à ton IP en prod
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh_http"
  }
}

# 7. Instance EC2
resource "aws_instance" "web" {
  ami           = "ami-000a08b963606bb82" # debian-11-amd64-20250402-2070 sur eu-east-1
  instance_type          = "t2.micro"
  key_name               = var.key_name
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.ssh_http.id]
  associate_public_ip_address = true
  user_data = file("install-ansible.sh")

  tags = {
    Name = "web-${var.ENVIRONMENT_NAME}"
  }
}

# 8. Output IP publique
output "ip_publique_web" {
  value       = aws_instance.web.public_ip
  description = "Adresse IP publique de la VM"
}



