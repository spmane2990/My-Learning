/* # AUTO_COMMENT_ADDED
   File: 09-expressions\variables.tf
   Purpose: Terraform configuration for the '09-expressions' tutorial folder.
   Summary: Declares input variables used to parameterize the configuration.
   See project-00-tutorial/readme.md for high-level details.
*/

/* AUTO_BLOCK_COMMENT
   Input variable: declares a configurable value for this module/configuration.
   Provide via -var, terraform.tfvars, or environment variables.
*/
variable "numbers_list" {
  type = list(number)
}

/* AUTO_BLOCK_COMMENT
   Input variable: declares a configurable value for this module/configuration.
   Provide via -var, terraform.tfvars, or environment variables.
*/
variable "numbers_map" {
  type = map(number)
}

/* AUTO_BLOCK_COMMENT
   Input variable: declares a configurable value for this module/configuration.
   Provide via -var, terraform.tfvars, or environment variables.
*/
variable "objects_list" {
  type = list(object({
    firstname = string
    lastname  = string
  }))
}

/* AUTO_BLOCK_COMMENT
   Input variable: declares a configurable value for this module/configuration.
   Provide via -var, terraform.tfvars, or environment variables.
*/
variable "users" {
  type = list(object({
    username = string
    role     = string
  }))
}

/* AUTO_BLOCK_COMMENT
   Input variable: declares a configurable value for this module/configuration.
   Provide via -var, terraform.tfvars, or environment variables.
*/
variable "user_to_output" {
  type = string
}
