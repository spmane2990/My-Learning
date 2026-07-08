/* # AUTO_COMMENT_ADDED
   File: 13-local-modules\modules\networking\examples\complete\main.tf
   Purpose: Terraform configuration for the 'complete' tutorial folder.
   Summary: Terraform configuration for this tutorial file.
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
      # Public subnets are indicated by setting the "public" option to true.
      public = true
      az     = "eu-west-1b"
    }
  }
}
