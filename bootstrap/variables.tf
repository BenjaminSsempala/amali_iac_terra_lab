
# define variables
variable "bucket_name" {
  type        = string
  description = "Bucket to store state file remotely"
}

variable "aws_region" {
  type    = string
  default = "eu-west-1"
}

variable "owner_tag" {
  type = string
}

variable "lab_tag" {
  type    = string
  default = "iac_lab"
}