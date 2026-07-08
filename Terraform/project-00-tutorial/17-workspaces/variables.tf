/* # AUTO_COMMENT_ADDED
   File: 17-workspaces\variables.tf
   Purpose: Terraform configuration for the '17-workspaces' tutorial folder.
   Summary: Declares input variables used to parameterize the configuration.
   See project-00-tutorial/readme.md for high-level details.
*/

/* AUTO_BLOCK_COMMENT
   Input variable: declares a configurable value for this module/configuration.
   Provide via -var, terraform.tfvars, or environment variables.
*/
variable "bucket_count" {
  type        = number
  description = "The number of S3 buckets to deploy."
}
