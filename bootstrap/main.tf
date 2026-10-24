

provider "aws" {
  region = var.aws_region
}

# define s3 bucket to store aws remote backend
resource "aws_s3_bucket" "remote_backend" {
  bucket = var.bucket_name

  tags = {
    Owner = var.owner_tag
    lab   = var.lab_tag
  }

  lifecycle {
    prevent_destroy = true
  }
}

# Enable versioning on bucket
resource "aws_s3_bucket_versioning" "remote_backend" {
  bucket = aws_s3_bucket.remote_backend.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Prevent Public access to bucket
resource "aws_s3_bucket_public_access_block" "remote_backend" {
  bucket = aws_s3_bucket.remote_backend.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

}


resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform_remote_backend_locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  lifecycle {
    prevent_destroy = true
  }

  attribute {
    name = "LockID"
    type = "S"
  }
}