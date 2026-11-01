terraform {
  required_version = ">=1.11.0"

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
    bucket  = "amali-iac-lab"
    region  = "eu-west-1"
    key     = "iacLab/terraform.tfstate"
    encrypt = true

    # S3-native locking (Terraform 1.11+). dynamodb_table is deprecated but
    # kept because this lab requires the DynamoDB lock table; with both set,
    # Terraform takes both locks.
    use_lockfile   = true
    dynamodb_table = "terraform_remote_backend_locks"
  }
}