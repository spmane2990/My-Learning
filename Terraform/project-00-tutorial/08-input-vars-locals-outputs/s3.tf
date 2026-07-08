/* # AUTO_COMMENT_ADDED
   File: 08-input-vars-locals-outputs\s3.tf
   Purpose: Terraform configuration for the '08-input-vars-locals-outputs' tutorial folder.
   Summary: S3 bucket and object configuration (website, policies, public access).
   See project-00-tutorial/readme.md for high-level details.
*/

/* AUTO_BLOCK_COMMENT
   Random ID: generates a short random value used to create unique names (avoids collisions).

   Block name: project_bucket_suffix
*/
resource "random_id" "project_bucket_suffix" {
  byte_length = 4
}

/* AUTO_BLOCK_COMMENT
   S3 bucket: creates a storage bucket. Often used for static sites, artifacts, or remote state.

   Block name: project_bucket
*/
resource "aws_s3_bucket" "project_bucket" {
  bucket = "${local.project}-${random_id.project_bucket_suffix.hex}"

  tags = merge(local.common_tags, var.additional_tags)
}
