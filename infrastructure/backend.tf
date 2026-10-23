terraform {
    required_version=">=1.5.0"

    required providers {
        aws = {
            source ="hashicorp/aws"
            version= "~>5.0"
        }
    }

    backend "s3" {
        bucket=var.bucket_name
        key="iacLab/terraform.tfstate"
        region=var.aws_region
        dynamodb_table="terraform_remote_backend_locks"
        encrypt=true
  }
}