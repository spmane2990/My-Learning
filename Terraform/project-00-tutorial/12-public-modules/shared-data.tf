/* # AUTO_COMMENT_ADDED
   File: 12-public-modules\shared-data.tf
   Purpose: Terraform configuration for the '12-public-modules' tutorial folder.
   Summary: Data sources used to look up existing provider data (AMIs, AZs).
   See project-00-tutorial/readme.md for high-level details.
*/

locals {
  project_name = "12-public-modules"
  common_tags = {
    Project   = local.project_name
    ManagedBy = "Terraform"
  }
}
