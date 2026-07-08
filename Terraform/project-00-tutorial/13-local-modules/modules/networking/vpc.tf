/* # AUTO_COMMENT_ADDED
   File: 13-local-modules\modules\networking\vpc.tf
   Purpose: Terraform configuration for the 'networking' tutorial folder.
   Summary: Networking resources (VPC, subnets, route tables, gateways).
   See project-00-tutorial/readme.md for high-level details.
*/

locals {
  public_subnets = {
    for key, config in var.subnet_config : key => config if config.public
  }

  private_subnets = {
    for key, config in var.subnet_config : key => config if !config.public
  }
}

/* AUTO_BLOCK_COMMENT
   Data source: reads information from the provider without creating new resources.

   Block name: available
*/
data "aws_availability_zones" "available" {
  state = "available"
}

/* AUTO_BLOCK_COMMENT
   VPC: virtual private cloud that provides an isolated network for resources.

   Block name: this
*/
resource "aws_vpc" "this" {
  cidr_block = var.vpc_config.cidr_block

  tags = {
    Name = var.vpc_config.name
  }
}

/* AUTO_BLOCK_COMMENT
   Subnet: a CIDR block within a VPC used to place resources (public/private).

   Block name: this
*/
resource "aws_subnet" "this" {
  for_each          = var.subnet_config
  vpc_id            = aws_vpc.this.id
  availability_zone = each.value.az
  cidr_block        = each.value.cidr_block

  tags = {
    Name   = each.key
    Access = each.value.public ? "Public" : "Private"
  }

  lifecycle {
    precondition {
      condition     = contains(data.aws_availability_zones.available.names, each.value.az)
      error_message = <<-EOT
      The AZ "${each.value.az}" provided for the subnet "${each.key}" is invalid.
      
      The applied AWS region "${data.aws_availability_zones.available.id}" supports the following AZs:
      [${join(", ", data.aws_availability_zones.available.names)}]
      EOT
    }
  }
}

/* AUTO_BLOCK_COMMENT
   Internet Gateway: attaches the VPC to the public internet.

   Block name: this
*/
resource "aws_internet_gateway" "this" {
  count  = length(local.public_subnets) > 0 ? 1 : 0
  vpc_id = aws_vpc.this.id
}

/* AUTO_BLOCK_COMMENT
   Route Table: contains routes used by subnets for network traffic (e.g., to IGW).

   Block name: public_rtb
*/
resource "aws_route_table" "public_rtb" {
  count  = length(local.public_subnets) > 0 ? 1 : 0
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this[0].id
  }
}

/* AUTO_BLOCK_COMMENT
   Route Table Association: links a subnet to a route table so the subnet follows those routes.

   Block name: public
*/
resource "aws_route_table_association" "public" {
  for_each = local.public_subnets

  subnet_id      = aws_subnet.this[each.key].id
  route_table_id = aws_route_table.public_rtb[0].id
}
