/* # AUTO_COMMENT_ADDED
   File: 13-local-modules\compute.tf
   Purpose: Terraform configuration for the '13-local-modules' tutorial folder.
   Summary: Contains compute/EC2 resource examples (instances, root_block_device, tags).
   See project-00-tutorial/readme.md for high-level details.
*/

locals {
  project_name = "13-local-modules"
}

/* AUTO_BLOCK_COMMENT
   Data source: looks up the most recent Ubuntu AMI (Canonical) matching a 22.04 image name.

   Block name: ubuntu
*/
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Owner is Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

/* AUTO_BLOCK_COMMENT
   EC2 Instance: launches a virtual machine using a chosen AMI and instance type.
   Shows root_block_device configuration and tagging examples.

   Block name: this
*/
resource "aws_instance" "this" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  subnet_id     = module.vpc.private_subnets["subnet_1"].subnet_id

  tags = {
    Name    = local.project_name
    Project = local.project_name
  }
}
