/* # AUTO_COMMENT_ADDED
   File: 03-first-tf-project\s3.tf
   Purpose: Terraform configuration for the '03-first-tf-project' tutorial folder.
   Summary: S3 bucket and object configuration (website, policies, public access).
   See project-00-tutorial/readme.md for high-level details.
*/

/* AUTO_BLOCK_COMMENT
   Random ID: generates a short random value used to create unique names (avoids collisions).

   Block name: bucket_suffix
*/
resource "random_id" "bucket_suffix" {
  byte_length = 6
}

/* AUTO_BLOCK_COMMENT
   S3 bucket: creates a storage bucket. Often used for static sites, artifacts, or remote state.

   Block name: example_bucket
*/
resource "aws_s3_bucket" "example_bucket" {
  bucket = "example-bucket-${random_id.bucket_suffix.hex}"
}

/* AUTO_BLOCK_COMMENT
   Output: exposes computed values after apply (useful for humans and CI).
*/
output "bucket_name" {
  value = aws_s3_bucket.example_bucket.bucket
}
