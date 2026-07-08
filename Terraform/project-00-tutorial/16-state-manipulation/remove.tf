/* # AUTO_COMMENT_ADDED
   File: 16-state-manipulation\remove.tf
   Purpose: Terraform configuration for the '16-state-manipulation' tutorial folder.
   Summary: State manipulation examples (import, move, taint, remove).
   See project-00-tutorial/readme.md for high-level details.
*/

/*
1. Remove via CLI
2. Remove via the removed block
*/

removed {
  from = aws_s3_bucket.my_new_bucket

  lifecycle {
    destroy = false
  }
}
