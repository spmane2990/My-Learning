/* # AUTO_COMMENT_ADDED
   File: 13-local-modules\modules\networking\variables.tf
   Purpose: Terraform configuration for the 'networking' tutorial folder.
   Summary: Declares input variables used to parameterize the configuration.
   See project-00-tutorial/readme.md for high-level details.
*/

/* AUTO_BLOCK_COMMENT
   Input variable: declares a configurable value for this module/configuration.
   Provide via -var, terraform.tfvars, or environment variables.
*/
variable "vpc_config" {
  type = object({
    cidr_block = string
    name       = string
  })

  validation {
    condition     = can(cidrnetmask(var.vpc_config.cidr_block))
    error_message = "The cidr_block config option must contain a valid CIDR block."
  }
}

/* AUTO_BLOCK_COMMENT
   Input variable: declares a configurable value for this module/configuration.
   Provide via -var, terraform.tfvars, or environment variables.
*/
variable "subnet_config" {
  type = map(object({
    cidr_block = string
    public     = optional(bool, false)
    az         = string
  }))

  validation {
    condition = alltrue([
      for config in values(var.subnet_config) : can(cidrnetmask(config.cidr_block))
    ])
    error_message = "The cidr_block config option must contain a valid CIDR block."
  }
}
