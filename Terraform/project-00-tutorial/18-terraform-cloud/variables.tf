/* # AUTO_COMMENT_ADDED
   File: 18-terraform-cloud\variables.tf
   Purpose: Terraform configuration for the '18-terraform-cloud' tutorial folder.
   Summary: Declares input variables used to parameterize the configuration.
   See project-00-tutorial/readme.md for high-level details.
*/

/* AUTO_BLOCK_COMMENT
   Input variable: declares a configurable value for this module/configuration.
   Provide via -var, terraform.tfvars, or environment variables.
*/
variable "ec2_instance_type" {
  type = string

  validation {
    condition     = var.ec2_instance_type == "t2.micro"
    error_message = "Please use t2.micro to stay within the free tier."
  }
}
