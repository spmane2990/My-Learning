/* # AUTO_COMMENT_ADDED
   File: 15-object-validation\variables.tf
   Purpose: Terraform configuration for the '15-object-validation' tutorial folder.
   Summary: Declares input variables used to parameterize the configuration.
   See project-00-tutorial/readme.md for high-level details.
*/

/* AUTO_BLOCK_COMMENT
   Input variable: declares a configurable value for this module/configuration.
   Provide via -var, terraform.tfvars, or environment variables.
*/
variable "instance_type" {
  type    = string
  default = "t2.micro"
}
