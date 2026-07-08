/* # AUTO_COMMENT_ADDED
   File: 16-state-manipulation\import.tf
   Purpose: Terraform configuration for the '16-state-manipulation' tutorial folder.
   Summary: State manipulation examples (import, move, taint, remove).
   See project-00-tutorial/readme.md for high-level details.
*/

/*
1. Import via CLI
2. Import via the import block
*/

/* AUTO_BLOCK_COMMENT
   S3 bucket: creates a storage bucket. Often used for static sites, artifacts, or remote state.

   Block name: remote_state
*/
resource "aws_s3_bucket" "remote_state" {
  bucket = "terraform-learning-somnathmane-remote-backend"

  tags = {
    ManagedBy = "Terraform"
  }
}

import {
  to = aws_s3_bucket_public_access_block.remote_state
  id = aws_s3_bucket.remote_state.bucket
}

/* AUTO_BLOCK_COMMENT
   S3 Public Access Block: controls default public access settings for the bucket (ACLs/policies).

   Block name: remote_state
*/
resource "aws_s3_bucket_public_access_block" "remote_state" {
  bucket = aws_s3_bucket.remote_state.bucket

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
