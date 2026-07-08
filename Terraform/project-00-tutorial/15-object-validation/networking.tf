/* # AUTO_COMMENT_ADDED
   File: 15-object-validation\networking.tf
   Purpose: Terraform configuration for the '15-object-validation' tutorial folder.
   Summary: Networking resources (VPC, subnets, route tables, gateways).
   See project-00-tutorial/readme.md for high-level details.
*/

/* AUTO_BLOCK_COMMENT
   Data source: reads information from the provider without creating new resources.

   Block name: default
*/
data "aws_vpc" "default" {
  default = true
}

/* AUTO_BLOCK_COMMENT
   Data source: reads information from the provider without creating new resources.

   Block name: available
*/
data "aws_availability_zones" "available" {
  state = "available"
}

/* AUTO_BLOCK_COMMENT
   Subnet: a CIDR block within a VPC used to place resources (public/private).

   Block name: this
*/
resource "aws_subnet" "this" {
  count      = 4
  vpc_id     = data.aws_vpc.default.id
  cidr_block = "172.31.${128 + count.index}.0/24"
  availability_zone = data.aws_availability_zones.available.names[
    count.index % length(data.aws_availability_zones.available.names)
  ]

  lifecycle {
    postcondition {
      condition     = contains(data.aws_availability_zones.available.names, self.availability_zone)
      error_message = "Invalid AZ"
    }
  }
}

check "high_availability_check" {
  assert {
    condition     = length(toset([for subnet in aws_subnet.this : subnet.availability_zone])) > 1
    error_message = <<-EOT
      You are deploying all subnets within the same AZ.
      Please consider distributing them across AZs for higher availability.
      EOT
  }
}
