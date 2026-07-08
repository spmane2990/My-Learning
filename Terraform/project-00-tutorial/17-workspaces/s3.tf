/* # AUTO_COMMENT_ADDED
   File: 17-workspaces\s3.tf
   Purpose: Terraform configuration for the '17-workspaces' tutorial folder.
   Summary: S3 bucket and object configuration (website, policies, public access).
   See project-00-tutorial/readme.md for high-level details.
*/

/* AUTO_BLOCK_COMMENT
   Random ID: generates a short random value used to create unique names (avoids collisions).

   Block name: bucket_suffix
*/
resource "random_id" "bucket_suffix" {
  byte_length = 4
}

/*
dev     -> 1 bucket
int     -> 1 bucket
staging -> 2 buckets
prod    -> 3 buckets
*/
/* AUTO_BLOCK_COMMENT
   S3 bucket: creates a storage bucket. Often used for static sites, artifacts, or remote state.

   Block name: this
*/
resource "aws_s3_bucket" "this" {
  count  = var.bucket_count
  bucket = "workspaces-demo-${terraform.workspace}-${count.index}-${random_id.bucket_suffix.hex}"
}
