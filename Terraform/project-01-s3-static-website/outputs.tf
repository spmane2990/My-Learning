/*
  Outputs
  - `static_website_endpoint`: the S3 website endpoint (e.g., `bucket-name.s3-website-eu-west-1.amazonaws.com`).
  - Useful for quickly verifying the deployed website URL after `terraform apply`.
*/
output "static_website_endpoint" {
  value = aws_s3_bucket_website_configuration.static_website.website_endpoint
}