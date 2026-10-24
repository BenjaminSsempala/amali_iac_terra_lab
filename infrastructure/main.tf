# Get machine ip on run
data "http" "local_ip"{
  url ="https://checkip.amazonaws.com"

  lifecycle {
    postcondition {
      condition     = self.status_code == 200
      error_message = "Could not reach checkip.amazonaws.com."
    }
  }
}

# Formart to required value
locals {
  my_ip_cidr = "${chomp(data.http.local_ip.response_body)}/32"
}

locals {
  use_existing_key = fileexists(var.existing_public_key_path)
}

# Create vpc for infra
resource "aws_vpc" "iac_lab_vpc" {
  cidr_block=var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    name = "aws_vpc"
  }
}

# Create public subnet for ec2 instance inside vpc
resource "aws_subnet" "iac_ec2_pub_subnet" {
  vpc_id=aws_vpc.iac_lab_vpc.id
  cidr_block=var.public_subnet_cidr
  map_public_ip_on_launch = true
  availability_zone       = var.availability_zone
  tags = {
      Name= "aws_subnet"
      
    }

}

# Gateway allows internet connection from inside a vpc
resource "aws_internet_gateway" "internet_gw" {
  vpc_id = aws_vpc.iac_lab_vpc.id

  tags = {
      Name= "internet_gw"
      
    }
}

# route table tells where connection requests are forwarded based off the detination IP
resource "aws_route_table" "route_tb" {
  vpc_id = aws_vpc.iac_lab_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gw.id
  }

  tags = {
      Name= "route_tb"
      
    }
}

# Associate rt with public subnet
resource "aws_route_table_association" "route_tb_ass" {
  subnet_id      = aws_subnet.iac_ec2_pub_subnet.id
  route_table_id = aws_route_table.route_tb.id
}

# Define allowed connections to ec2 instance under this sg
resource "aws_security_group" "iac_ec2_sg" {
  name        = "amali-lab-iac-ec2-sg"
  description = "Allow HTTP and restricted SSH"
  vpc_id      = aws_vpc.iac_lab_vpc.id

  lifecycle {
    precondition {
      condition     = can(cidrnetmask(local.my_ip_cidr))
      error_message = "Could not get a valid public IP for the SSH rule."
    }
  }

  ingress {
    description = "SSH from my IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [local.my_ip_cidr]
  }

  ingress {
    description = "HTTP from the internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
      Name= "iac_ec2_sg"
      
    }
}

# Generate an SSH key pair
resource "tls_private_key" "ssh" {
  count     = local.use_existing_key ? 0 : 1
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Upload the public key to AWS
resource "aws_key_pair" "lab_key" {
  key_name   = "amali-iac-lab-key"
  public_key = local.use_existing_key ? file(var.existing_public_key_path) : tls_private_key.ssh[0].public_key_openssh
}

# Save the private key
resource "local_sensitive_file" "private_key" {
  count           = local.use_existing_key ? 0 : 1
  content         = tls_private_key.ssh[0].private_key_openssh
  filename        = "${path.module}/amali-iac-lab-key.pem"
  file_permission = "0400"
}

resource "aws_instance" "iac_lab_ec2" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.iac_ec2_pub_subnet.id
  vpc_security_group_ids      = [aws_security_group.iac_ec2_sg.id]
  associate_public_ip_address = true
  key_name                    = aws_key_pair.lab_key.key_name

  tags = {
      Name= "iac_lab_ec2"
    }
}

