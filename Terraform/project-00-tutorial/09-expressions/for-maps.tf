/* # AUTO_COMMENT_ADDED
   File: 09-expressions\for-maps.tf
   Purpose: Terraform configuration for the '09-expressions' tutorial folder.
   Summary: Terraform configuration for this tutorial file.
   See project-00-tutorial/readme.md for high-level details.
*/

locals {
  doubles_map = { for key, value in var.numbers_map : key => value * 2 }
  even_map = { for key, value in var.numbers_map : key =>
    value * 2 if value % 2 == 0
  }
}

/* AUTO_BLOCK_COMMENT
   Output: exposes computed values after apply (useful for humans and CI).
*/
output "doubles_map" {
  value = local.doubles_map
}

/* AUTO_BLOCK_COMMENT
   Output: exposes computed values after apply (useful for humans and CI).
*/
output "even_map" {
  value = local.even_map
}
