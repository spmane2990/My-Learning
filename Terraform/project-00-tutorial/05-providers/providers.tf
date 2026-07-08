/* # AUTO_COMMENT_ADDED
   File: 05-providers\providers.tf
   Purpose: Terraform configuration for the '05-providers' tutorial folder.
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

/* AUTO_BLOCK_COMMENT
   Provider configuration: sets provider-specific settings (region, credentials, aliases).
*/
provider "aws" {
  region = "us-east-1"
  alias  = "us-east"
}

/* AUTO_BLOCK_COMMENT
   S3 bucket: creates a storage bucket. Often used for static sites, artifacts, or remote state.

   Block name: eu_west_1
*/
resource "aws_s3_bucket" "eu_west_1" {
  bucket = "some-random-bucket-name-aosdhfoadhfu"
}

/* AUTO_BLOCK_COMMENT
   S3 bucket: creates a storage bucket. Often used for static sites, artifacts, or remote state.

   Block name: us_east_1
*/
resource "aws_s3_bucket" "us_east_1" {
  bucket   = "some-random-bucket-name-18736481364"
  provider = aws.us-east
}
