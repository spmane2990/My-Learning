/* # AUTO_COMMENT_ADDED
   File: 08-input-vars-locals-outputs\shared-locals.tf
   Purpose: Terraform configuration for the '08-input-vars-locals-outputs' tutorial folder.
   Summary: Local values and shared data used to compute derived values.
   See project-00-tutorial/readme.md for high-level details.
*/

locals {
  project       = "08-input-vars-locals-outputs"
  project_owner = "terraform-learning"
  cost_center   = "1234"
  managed_by    = "Terraform"
}

locals {
  common_tags = {
    project       = local.project
    project_owner = local.project_owner
    cost_center   = local.cost_center
    managed_by    = local.managed_by
    sensitive_tag = var.my_sensitive_value
  }
}
