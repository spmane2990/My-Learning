/* # AUTO_COMMENT_ADDED
   File: 16-state-manipulation\modules\compute\variables.tf
   Purpose: Terraform configuration for the 'compute' tutorial folder.
   Summary: Declares input variables used to parameterize the configuration.
   See project-00-tutorial/readme.md for high-level details.
*/

/* AUTO_BLOCK_COMMENT
   Input variable: declares a configurable value for this module/configuration.
   Provide via -var, terraform.tfvars, or environment variables.
*/
variable "ami_id" {
  type        = string
  description = "The ID of the AMI to use for the EC2 instance."
}
