/* # AUTO_COMMENT_ADDED
   File: 14-use-own-module\networking.tf
   Purpose: Terraform configuration for the '14-use-own-module' tutorial folder.
   Summary: Networking resources (VPC, subnets, route tables, gateways).
   See project-00-tutorial/readme.md for high-level details.
*/

/* AUTO_BLOCK_COMMENT
   Module block: re-uses infrastructure defined elsewhere; pass inputs and capture outputs.
*/
module "networking-tf-learning" {
  source  = "somnathmane/networking-tf-learning/aws"
  version = "0.1.1"

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
  }
}
