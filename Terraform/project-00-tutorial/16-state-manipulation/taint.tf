/* # AUTO_COMMENT_ADDED
   File: 16-state-manipulation\taint.tf
   Purpose: Terraform configuration for the '16-state-manipulation' tutorial folder.
   Summary: State manipulation examples (import, move, taint, remove).
   See project-00-tutorial/readme.md for high-level details.
*/

/* AUTO_BLOCK_COMMENT
   S3 bucket: creates a storage bucket. Often used for static sites, artifacts, or remote state.

   Block name: tainted
*/
resource "aws_s3_bucket" "tainted" {
  bucket = "my-tainted-bucket-19384981jhahds"
}

/* AUTO_BLOCK_COMMENT
   S3 Public Access Block: controls default public access settings for the bucket (ACLs/policies).

   Block name: from_tainted
*/
resource "aws_s3_bucket_public_access_block" "from_tainted" {
  bucket = aws_s3_bucket.tainted.bucket

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

/* AUTO_BLOCK_COMMENT
   VPC: virtual private cloud that provides an isolated network for resources.

   Block name: this
*/
resource "aws_vpc" "this" {
  cidr_block = "10.0.0.0/16"
}

/* AUTO_BLOCK_COMMENT
   Subnet: a CIDR block within a VPC used to place resources (public/private).

   Block name: this
*/
resource "aws_subnet" "this" {
  vpc_id     = aws_vpc.this.id
  cidr_block = "10.0.0.0/24"
}
