/* # AUTO_COMMENT_ADDED
   File: 02-hcl\hcl.tf
   Purpose: Terraform configuration for the '02-hcl' tutorial folder.
   Summary: Terraform configuration for this tutorial file.
   See project-00-tutorial/readme.md for high-level details.
*/

/* AUTO_BLOCK_COMMENT
   Terraform settings block: declares required providers and Terraform version constraints.
*/
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.37.0"
    }
  }
}

# Actively managed by us, by our Terraform project
/* AUTO_BLOCK_COMMENT
   S3 bucket: creates a storage bucket. Often used for static sites, artifacts, or remote state.

   Block name: my_bucket
*/
resource "aws_s3_bucket" "my_bucket" {
  bucket = var.bucket_name
}

# Managed somewhere else, we just want to use in our project
/* AUTO_BLOCK_COMMENT
   Data source: reads information from the provider without creating new resources.

   Block name: my_external_bucket
*/
data "aws_s3_bucket" "my_external_bucket" {
  bucket = "not-managed-by-us"
}

/* AUTO_BLOCK_COMMENT
   Input variable: declares a configurable value for this module/configuration.
   Provide via -var, terraform.tfvars, or environment variables.
*/
variable "bucket_name" {
  type        = string
  description = "My variable used to set bucket name"
  default     = "my_default_bucket_name"
}

/* AUTO_BLOCK_COMMENT
   Output: exposes computed values after apply (useful for humans and CI).
*/
output "bucket_id" {
  value = aws_s3_bucket.my_bucket.id
}

locals {
  local_example = "This is a local variable"
}

/* AUTO_BLOCK_COMMENT
   Module block: re-uses infrastructure defined elsewhere; pass inputs and capture outputs.
*/
module "my_module" {
  source = "./module-example"
}
