/* # AUTO_COMMENT_ADDED
   File: 08-input-vars-locals-outputs\outputs.tf
   Purpose: Terraform configuration for the '08-input-vars-locals-outputs' tutorial folder.
   Summary: Declares outputs exposed after apply for human or CI consumption.
   See project-00-tutorial/readme.md for high-level details.
*/

/* AUTO_BLOCK_COMMENT
   Output: exposes computed values after apply (useful for humans and CI).
*/
output "s3_bucket_name" {
  value       = aws_s3_bucket.project_bucket.bucket
  sensitive   = true
  description = "The name of the S3 bucket"
}

/* AUTO_BLOCK_COMMENT
   Output: exposes computed values after apply (useful for humans and CI).
*/
output "sensitive_var" {
  sensitive = true
  value     = var.my_sensitive_value
}
