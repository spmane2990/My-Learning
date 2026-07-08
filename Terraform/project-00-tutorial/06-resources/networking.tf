/* # AUTO_COMMENT_ADDED
   File: 06-resources\networking.tf
   Purpose: Terraform configuration for the '06-resources' tutorial folder.
   Summary: Networking resources (VPC, subnets, route tables, gateways).
   See project-00-tutorial/readme.md for high-level details.
*/

locals {
  common_tags = {
    ManagedBy  = "Terraform"
    Project    = "06-resources"
    CostCenter = "1234"
  }
}

/* AUTO_BLOCK_COMMENT
   VPC: virtual private cloud that provides an isolated network for resources.

   Block name: main
*/
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = merge(local.common_tags, {
    Name = "06-resources"
  })
}

/* AUTO_BLOCK_COMMENT
   Subnet: a CIDR block within a VPC used to place resources (public/private).

   Block name: public
*/
resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.0.0/24"

  tags = merge(local.common_tags, {
    Name = "06-resources-public"
  })
}

/* AUTO_BLOCK_COMMENT
   Internet Gateway: attaches the VPC to the public internet.

   Block name: main
*/
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(local.common_tags, {
    Name = "06-resources-main"
  })
}

/* AUTO_BLOCK_COMMENT
   Route Table: contains routes used by subnets for network traffic (e.g., to IGW).

   Block name: public
*/
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = merge(local.common_tags, {
    Name = "06-resources-main"
  })
}

/* AUTO_BLOCK_COMMENT
   Route Table Association: links a subnet to a route table so the subnet follows those routes.

   Block name: public
*/
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}
