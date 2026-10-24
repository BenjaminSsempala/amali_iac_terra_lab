
# define variables

variable "aws_region" {
  type    = string
  default = "eu-west-1"
}

variable "owner_tag" {
  type    = string
  default = "ssempala_benjamin"
}

variable "availability_zone" {
  type    = string
  default = "eu-west-1a"
}

variable "lab_tag" {
  type    = string
  default = "iac_lab"
}

variable "ami_id" {
  type = string
}


variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "existing_public_key_path" {
  type    = string
  default = "~/.ssh/amali-iac-lab.pub"
}

