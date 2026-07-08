/* # AUTO_COMMENT_ADDED
   File: 09-expressions\for-lists.tf
   Purpose: Terraform configuration for the '09-expressions' tutorial folder.
   Summary: Terraform configuration for this tutorial file.
   See project-00-tutorial/readme.md for high-level details.
*/

locals {
  double_numbers = [for num in var.numbers_list : num * 2]
  even_numbers   = [for num in var.numbers_list : num if num % 2 == 0]
  firstnames     = [for person in var.objects_list : person.firstname]
  fullnames = [
    for person in var.objects_list : "${person.firstname} ${person.lastname}"
  ]
}

/* AUTO_BLOCK_COMMENT
   Output: exposes computed values after apply (useful for humans and CI).
*/
output "double_numbers" {
  value = local.double_numbers
}

/* AUTO_BLOCK_COMMENT
   Output: exposes computed values after apply (useful for humans and CI).
*/
output "even_numbers" {
  value = local.even_numbers
}

/* AUTO_BLOCK_COMMENT
   Output: exposes computed values after apply (useful for humans and CI).
*/
output "firstnames" {
  value = local.firstnames
}

/* AUTO_BLOCK_COMMENT
   Output: exposes computed values after apply (useful for humans and CI).
*/
output "fullnames" {
  value = local.fullnames
}
