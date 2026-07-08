/*
  Terraform settings
  - `required_version` ensures a compatible Terraform core version.
  - `required_providers` declares provider plugins and their version constraints.
*/
terraform {
  required_version = "~> 1.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

/*
  AWS provider configuration
  - Configures provider-level settings such as the target AWS region.
  - Credentials are provided via environment variables or the AWS shared credentials file.
*/
provider "aws" {
  region = "eu-west-1"
}