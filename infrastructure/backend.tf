terraform {
  required_version = ">=1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>6.0"

    }

    http = {
      source  = "hashicorp/http"
      version = "~> 3.4"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }

    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }

  backend "s3" {
    bucket         = "amali-iac-lab"
    region         = "eu-west-1"
    key            = "iacLab/terraform.tfstate"
    dynamodb_table = "terraform_remote_backend_locks"
    encrypt        = true
  }
}