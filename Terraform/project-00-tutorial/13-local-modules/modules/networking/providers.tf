/* # AUTO_COMMENT_ADDED
   File: 13-local-modules\modules\networking\providers.tf
   Purpose: Terraform configuration for the 'networking' tutorial folder.
   Summary: Provider configuration (region, credentials, provider-specific settings).
   See project-00-tutorial/readme.md for high-level details.
*/

/* AUTO_BLOCK_COMMENT
   Terraform settings block: declares required providers and Terraform version constraints.
*/
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
