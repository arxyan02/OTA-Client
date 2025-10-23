terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 1.6.0"
}

provider "aws" {
  region = "ap-south-1"
}

##############################
# S3 Bucket for Terraform State
##############################

resource "aws_s3_bucket" "tf_state" {
  bucket = "valtech-ota-tfstate-bucket"

  tags = {
    Name        = "Terraform State Bucket"
    Environment = "Shared"
    ManagedBy   = "Terraform"
  }
}

# Enforce secure ownership model replacing deprecated ACLs
resource "aws_s3_bucket_ownership_controls" "tf_state_ownership" {
  bucket = aws_s3_bucket.tf_state.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

# Block all public access
resource "aws_s3_bucket_public_access_block" "tf_state_block" {
  bucket                  = aws_s3_bucket.tf_state.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Enable versioning to protect historical state data
resource "aws_s3_bucket_versioning" "tf_state_versioning" {
  bucket = aws_s3_bucket.tf_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Server-side encryption for state file security
resource "aws_s3_bucket_server_side_encryption_configuration" "tf_state_encryption" {
  bucket = aws_s3_bucket.tf_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

##############################
# DynamoDB Table for State Locking
##############################

resource "aws_dynamodb_table" "tf_locks" {
  name         = "valtech-ota-terraform-state-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name        = "Terraform State Locks"
    Environment = "Shared"
    ManagedBy   = "Terraform"
  }
}

##############################
# Outputs
##############################

output "state_bucket" {
  description = "Name of the S3 bucket for storing Terraform state"
  value       = aws_s3_bucket.tf_state.bucket
}

output "lock_table" {
  description = "Name of the DynamoDB table for Terraform state locks"
  value       = aws_dynamodb_table.tf_locks.name
}
