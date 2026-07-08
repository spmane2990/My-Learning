/* # AUTO_COMMENT_ADDED
   File: 13-local-modules\outputs.tf
   Purpose: Terraform configuration for the '13-local-modules' tutorial folder.
   Summary: Declares outputs exposed after apply for human or CI consumption.
   See project-00-tutorial/readme.md for high-level details.
*/

/* AUTO_BLOCK_COMMENT
   Output: exposes computed values after apply (useful for humans and CI).
*/
output "module_vpc_id" {
  value = module.vpc.vpc_id
}

/* AUTO_BLOCK_COMMENT
   Output: exposes computed values after apply (useful for humans and CI).
*/
output "module_public_subnets" {
  value = module.vpc.public_subnets
}

/* AUTO_BLOCK_COMMENT
   Output: exposes computed values after apply (useful for humans and CI).
*/
output "module_private_subnets" {
  value = module.vpc.private_subnets
}
