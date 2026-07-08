/* # AUTO_COMMENT_ADDED
   File: 15-object-validation\provider.tf
   Purpose: Terraform configuration for the '15-object-validation' tutorial folder.
   Summary: Provider configuration (region, credentials, provider-specific settings).
   See project-00-tutorial/readme.md for high-level details.
*/

/* AUTO_BLOCK_COMMENT
   Terraform settings block: declares required providers and Terraform version constraints.
*/
terraform {
  required_version = "~> 1.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

/* AUTO_BLOCK_COMMENT
   Provider configuration: sets provider-specific settings (region, credentials, aliases).
*/
provider "aws" {
  region = "eu-west-1"
}
