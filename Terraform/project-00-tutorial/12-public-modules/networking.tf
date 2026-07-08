/* # AUTO_COMMENT_ADDED
   File: 12-public-modules\networking.tf
   Purpose: Terraform configuration for the '12-public-modules' tutorial folder.
   Summary: Networking resources (VPC, subnets, route tables, gateways).
   See project-00-tutorial/readme.md for high-level details.
*/

locals {
  vpc_cidr             = "10.0.0.0/16"
  private_subnet_cidrs = ["10.0.0.0/24"]
  public_subnet_cidrs  = ["10.0.128.0/24"]
}

/* AUTO_BLOCK_COMMENT
   Data source: reads information from the provider without creating new resources.

   Block name: azs
*/
data "aws_availability_zones" "azs" {
  state = "available"
}

/* AUTO_BLOCK_COMMENT
   Module block: re-uses infrastructure defined elsewhere; pass inputs and capture outputs.
*/
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.5.3"

  cidr            = local.vpc_cidr
  name            = local.project_name
  azs             = data.aws_availability_zones.azs.names
  private_subnets = local.private_subnet_cidrs
  public_subnets  = local.public_subnet_cidrs

  tags = local.common_tags
}
