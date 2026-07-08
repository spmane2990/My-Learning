/* # AUTO_COMMENT_ADDED
   File: 08-input-vars-locals-outputs\variables.tf
   Purpose: Terraform configuration for the '08-input-vars-locals-outputs' tutorial folder.
   Summary: Declares input variables used to parameterize the configuration.
   See project-00-tutorial/readme.md for high-level details.
*/

/* AUTO_BLOCK_COMMENT
   Input variable: declares a configurable value for this module/configuration.
   Provide via -var, terraform.tfvars, or environment variables.
*/
variable "ec2_instance_type" {
  type        = string
  description = "The type of the managed EC2 instances."

  validation {
    condition     = contains(["t2.micro", "t3.micro"], var.ec2_instance_type)
    error_message = "Only supports t2.micro and t3.micro"
  }
}

/* AUTO_BLOCK_COMMENT
   Input variable: declares a configurable value for this module/configuration.
   Provide via -var, terraform.tfvars, or environment variables.
*/
variable "ec2_volume_config" {
  type = object({
    size = number
    type = string
  })
  description = "The size and type of the root block volume for EC2 instances."

  default = {
    size = 10
    type = "gp3"
  }
}

/* AUTO_BLOCK_COMMENT
   Input variable: declares a configurable value for this module/configuration.
   Provide via -var, terraform.tfvars, or environment variables.
*/
variable "additional_tags" {
  type    = map(string)
  default = {}
}

/* AUTO_BLOCK_COMMENT
   Input variable: declares a configurable value for this module/configuration.
   Provide via -var, terraform.tfvars, or environment variables.
*/
variable "my_sensitive_value" {
  type      = string
  sensitive = true
}
