/* # AUTO_COMMENT_ADDED
   File: 18-terraform-cloud\s3.tf
   Purpose: Terraform configuration for the '18-terraform-cloud' tutorial folder.
   Summary: S3 bucket and object configuration (website, policies, public access).
   See project-00-tutorial/readme.md for high-level details.
*/

/* AUTO_BLOCK_COMMENT
   S3 bucket: creates a storage bucket. Often used for static sites, artifacts, or remote state.

   Block name: tf_cloud
*/
resource "aws_s3_bucket" "tf_cloud" {
  bucket = "terraform-cloud-${random_id.this.hex}"

  tags = {
    CreatedBy = "Terraform Cloud"
  }
}
