/* # AUTO_COMMENT_ADDED
   File: 09-expressions\operators.tf
   Purpose: Terraform configuration for the '09-expressions' tutorial folder.
   Summary: Terraform configuration for this tutorial file.
   See project-00-tutorial/readme.md for high-level details.
*/

locals {
  math       = 2 * 2  # Math operators: *, /, +, -, -<number>
  equality   = 2 != 2 # Equality operators: ==, !=
  comparison = 2 < 1  # Comparison operators: <, <=, >, >=
  logical    = true || false
}

/* AUTO_BLOCK_COMMENT
   Output: exposes computed values after apply (useful for humans and CI).
*/
output "operators" {
  value = {
    math       = local.math
    equality   = local.equality
    comparison = local.comparison
    logical    = local.logical
  }
}
