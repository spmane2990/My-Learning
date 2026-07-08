/* # AUTO_COMMENT_ADDED
   File: 13-local-modules\modules\networking\outputs.tf
   Purpose: Terraform configuration for the 'networking' tutorial folder.
   Summary: Declares outputs exposed after apply for human or CI consumption.
   See project-00-tutorial/readme.md for high-level details.
*/

# 1. VPC ID
# 2. Public subnets - subnet_key => { subnet_id, availability_zone }
# 3. Private subnets - subnet_key => { subnet_id, availability_zone }

locals {
  output_public_subnets = {
    for key in keys(local.public_subnets) : key => {
      subnet_id         = aws_subnet.this[key].id
      availability_zone = aws_subnet.this[key].availability_zone
    }
  }

  output_private_subnets = {
    for key in keys(local.private_subnets) : key => {
      subnet_id         = aws_subnet.this[key].id
      availability_zone = aws_subnet.this[key].availability_zone
    }
  }
}

/* AUTO_BLOCK_COMMENT
   Output: exposes computed values after apply (useful for humans and CI).
*/
output "vpc_id" {
  description = "The AWS ID from the created VPC"
  value       = aws_vpc.this.id
}

/* AUTO_BLOCK_COMMENT
   Output: exposes computed values after apply (useful for humans and CI).
*/
output "public_subnets" {
  description = "The ID and the availability zone of public subnets."
  value       = local.output_public_subnets
}

/* AUTO_BLOCK_COMMENT
   Output: exposes computed values after apply (useful for humans and CI).
*/
output "private_subnets" {
  description = "The ID and the availability zone of private subnets."
  value       = local.output_private_subnets
}
