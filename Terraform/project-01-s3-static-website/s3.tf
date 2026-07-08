/*
  Random ID for bucket suffix
  - Generates a short, random suffix to append to the S3 bucket name so it is likely unique.
  - `byte_length = 4` produces an 8-character hex string in `random_id.bucket_suffix.hex`.
*/
resource "random_id" "bucket_suffix" {
  byte_length = 4
}

/*
  S3 bucket for static website
  - Creates the bucket used to host the static website files.
  - The bucket name includes the random suffix to avoid name collisions across AWS.
*/
resource "aws_s3_bucket" "static_website" {
  bucket = "terraform-learning-project-1-${random_id.bucket_suffix.hex}"
}

/*
  Public access block configuration
  - Controls account/bucket-level public access settings for the S3 bucket.
  - Here all blocking features are disabled so the bucket can be made public for website hosting.
  - In production consider stricter settings or serving the site via CloudFront with a private bucket.
*/
resource "aws_s3_bucket_public_access_block" "static_website" {
  bucket                  = aws_s3_bucket.static_website.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

/*
  Bucket policy granting public read access
  - Allows anonymous `s3:GetObject` on all objects in the bucket so the website is publicly accessible.
  - Use with caution: for secure deployments prefer CloudFront + Origin Access Control instead.
*/
resource "aws_s3_bucket_policy" "static_website_public_read" {
  bucket = aws_s3_bucket.static_website.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.static_website.arn}/*"
      }
    ]
  })
}

/*
  S3 website configuration
  - Enables S3 static website hosting and sets the index and error documents.
  - The `website_endpoint` attribute is exposed via outputs for verification.
*/
resource "aws_s3_bucket_website_configuration" "static_website" {
  bucket = aws_s3_bucket.static_website.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

/*
  Upload example site files
  - These resources upload local files from `build/` into the S3 bucket as objects.
  - `etag = filemd5(...)` helps Terraform detect changes to the local files and update objects accordingly.
  - `content_type` ensures the objects are served with the correct MIME type.
*/
resource "aws_s3_object" "index_html" {
  bucket       = aws_s3_bucket.static_website.id
  key          = "index.html"
  source       = "build/index.html"
  etag         = filemd5("build/index.html")
  content_type = "text/html"
}

resource "aws_s3_object" "error_html" {
  bucket       = aws_s3_bucket.static_website.id
  key          = "error.html"
  source       = "build/error.html"
  etag         = filemd5("build/error.html")
  content_type = "text/html"
}