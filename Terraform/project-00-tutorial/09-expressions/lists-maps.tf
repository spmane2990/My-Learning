/* # AUTO_COMMENT_ADDED
   File: 09-expressions\lists-maps.tf
   Purpose: Terraform configuration for the '09-expressions' tutorial folder.
   Summary: Terraform configuration for this tutorial file.
   See project-00-tutorial/readme.md for high-level details.
*/

locals {
  users_map = {
    for user_info in var.users : user_info.username => user_info.role...
  }
  users_map2 = {
    for username, roles in local.users_map : username => {
      roles = roles
    }
  }
  usernames_from_map = [for username, roles in local.users_map : username]
}

/* AUTO_BLOCK_COMMENT
   Output: exposes computed values after apply (useful for humans and CI).
*/
output "users_map" {
  value = local.users_map
}

/* AUTO_BLOCK_COMMENT
   Output: exposes computed values after apply (useful for humans and CI).
*/
output "users_map2" {
  value = local.users_map2
}

/* AUTO_BLOCK_COMMENT
   Output: exposes computed values after apply (useful for humans and CI).
*/
output "usernames_from_map" {
  value = local.usernames_from_map
}

/* AUTO_BLOCK_COMMENT
   Output: exposes computed values after apply (useful for humans and CI).
*/
output "user_to_output_roles" {
  value = local.users_map2[var.user_to_output].roles
}
