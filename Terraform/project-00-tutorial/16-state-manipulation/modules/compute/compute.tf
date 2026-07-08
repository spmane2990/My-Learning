/* # AUTO_COMMENT_ADDED
   File: 16-state-manipulation\modules\compute\compute.tf
   Purpose: Terraform configuration for the 'compute' tutorial folder.
   Summary: Contains compute/EC2 resource examples (instances, root_block_device, tags).
   See project-00-tutorial/readme.md for high-level details.
*/

/* AUTO_BLOCK_COMMENT
   EC2 Instance: launches a virtual machine using a chosen AMI and instance type.
   Shows root_block_device configuration and tagging examples.

   Block name: this
*/
resource "aws_instance" "this" {
  ami           = var.ami_id
  instance_type = "t2.micro"
}
