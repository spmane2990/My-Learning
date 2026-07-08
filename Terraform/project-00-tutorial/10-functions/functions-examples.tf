/* # AUTO_COMMENT_ADDED
   File: 10-functions\functions-examples.tf
   Purpose: Terraform configuration for the '10-functions' tutorial folder.
   Summary: Examples of Terraform built-in functions and data transformations.
   See project-00-tutorial/readme.md for high-level details.
*/

locals {
  name = "Somnath Mane"
  age  = -15
  my_object = {
    key1 = 10
    key2 = "my_value"
  }
}

/* AUTO_BLOCK_COMMENT
   Output: exposes computed values after apply (useful for humans and CI).
*/
output "example1" {
  value = startswith(lower(local.name), "john")
}

/* AUTO_BLOCK_COMMENT
   Output: exposes computed values after apply (useful for humans and CI).
*/
output "example2" {
  value = pow(local.age, 2)
}

/* AUTO_BLOCK_COMMENT
   Output: exposes computed values after apply (useful for humans and CI).
*/
output "example3" {
  value = yamldecode(file("${path.module}/users.yaml")).users[*].name
}

/* AUTO_BLOCK_COMMENT
   Output: exposes computed values after apply (useful for humans and CI).
*/
output "example4" {
  value = jsonencode(local.my_object)
}
