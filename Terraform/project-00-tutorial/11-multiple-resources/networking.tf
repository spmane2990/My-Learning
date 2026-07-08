/* # AUTO_COMMENT_ADDED
   File: 11-multiple-resources\networking.tf
   Purpose: Terraform configuration for the '11-multiple-resources' tutorial folder.
   Summary: Networking resources (VPC, subnets, route tables, gateways).
   See project-00-tutorial/readme.md for high-level details.
*/

/* AUTO_BLOCK_COMMENT
   VPC: virtual private cloud that provides an isolated network for resources.

   Block name: main
*/
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Project = local.project
    Name    = local.project
  }
}

/* AUTO_BLOCK_COMMENT
   Subnet: a CIDR block within a VPC used to place resources (public/private).

   Block name: main
*/
resource "aws_subnet" "main" {
  for_each   = var.subnet_config
  vpc_id     = aws_vpc.main.id
  cidr_block = each.value.cidr_block

  tags = {
    Project = local.project
    Name    = "${local.project}-${each.key}"
  }
}
