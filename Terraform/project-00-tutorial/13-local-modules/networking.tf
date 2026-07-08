/* # AUTO_COMMENT_ADDED
   File: 13-local-modules\networking.tf
   Purpose: Terraform configuration for the '13-local-modules' tutorial folder.
   Summary: Networking resources (VPC, subnets, route tables, gateways).
   See project-00-tutorial/readme.md for high-level details.
*/

/* AUTO_BLOCK_COMMENT
   Module block: re-uses infrastructure defined elsewhere; pass inputs and capture outputs.
*/
module "vpc" {
  source = "./modules/networking"

  vpc_config = {
    cidr_block = "10.0.0.0/16"
    name       = "13-local-modules"
  }

  subnet_config = {
    subnet_1 = {
      cidr_block = "10.0.0.0/24"
      az         = "eu-west-1a"
    }
    subnet_2 = {
      cidr_block = "10.0.1.0/24"
      public     = true
      az         = "eu-west-1b"
    }
    subnet_3 = {
      cidr_block = "10.0.2.0/24"
      public     = true
      az         = "eu-west-1c"
    }
    subnet_4 = {
      cidr_block = "10.0.3.0/24"
      az         = "eu-west-1a"
    }
  }
}
