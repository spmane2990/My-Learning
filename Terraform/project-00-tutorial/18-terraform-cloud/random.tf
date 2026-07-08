/* # AUTO_COMMENT_ADDED
   File: 18-terraform-cloud\random.tf
   Purpose: Terraform configuration for the '18-terraform-cloud' tutorial folder.
   Summary: Random ID/value generation used for unique names.
   See project-00-tutorial/readme.md for high-level details.
*/

/* AUTO_BLOCK_COMMENT
   Random ID: generates a short random value used to create unique names (avoids collisions).

   Block name: this
*/
resource "random_id" "this" {
  byte_length = 4
}

/* AUTO_BLOCK_COMMENT
   Output: exposes computed values after apply (useful for humans and CI).
*/
output "random_id" {
  value = random_id.this.hex
}
