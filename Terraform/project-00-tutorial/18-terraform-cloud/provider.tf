/* # AUTO_COMMENT_ADDED
   File: 18-terraform-cloud\provider.tf
   Purpose: Terraform configuration for the '18-terraform-cloud' tutorial folder.
   Summary: Provider configuration (region, credentials, provider-specific settings).
   See project-00-tutorial/readme.md for high-level details.
*/

/* AUTO_BLOCK_COMMENT
   Terraform settings block: declares required providers and Terraform version constraints.
*/
terraform {
  cloud {
    organization = "SomnathMane"

    workspaces {
      name = "terraform-cli"
    }
  }

  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }

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
