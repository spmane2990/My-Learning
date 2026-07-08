/* # AUTO_COMMENT_ADDED
   File: 09-expressions\splat.tf
   Purpose: Terraform configuration for the '09-expressions' tutorial folder.
   Summary: Terraform configuration for this tutorial file.
   See project-00-tutorial/readme.md for high-level details.
*/

locals {
  firstnames_from_splat        = var.objects_list[*].firstname
  roles_from_splat             = [for username, user_props in local.users_map2 : user_props.roles]
  roles_from_splat_with_values = values(local.users_map2)[*].roles
}

/* AUTO_BLOCK_COMMENT
   Output: exposes computed values after apply (useful for humans and CI).
*/
output "firstnames_from_splat" {
  value = local.firstnames_from_splat
}

/* AUTO_BLOCK_COMMENT
   Output: exposes computed values after apply (useful for humans and CI).
*/
output "roles_from_splat" {
  value = local.roles_from_splat
}
