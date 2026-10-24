provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      lab   = var.lab_tag
      owner = var.owner_tag
    }

  }
}