/* # AUTO_COMMENT_ADDED
   File: 16-state-manipulation\move-state.tf
   Purpose: Terraform configuration for the '16-state-manipulation' tutorial folder.
   Summary: State manipulation examples (import, move, taint, remove).
   See project-00-tutorial/readme.md for high-level details.
*/

locals {
  ec2_names = ["instance1", "instance2"]
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

moved {
  from = aws_instance.new_list[0]
  to   = aws_instance.new_list["instance1"]
}

moved {
  from = aws_instance.new_list[1]
  to   = aws_instance.new_list["instance2"]
}

moved {
  from = aws_instance.new_list["instance1"]
  to   = aws_instance.new_final
}

moved {
  from = aws_instance.new_list["instance2"]
  to   = module.compute.aws_instance.this
}

/* AUTO_BLOCK_COMMENT
   EC2 Instance: launches a virtual machine using a chosen AMI and instance type.
   Shows root_block_device configuration and tagging examples.

   Block name: new_final
*/
resource "aws_instance" "new_final" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
}

/* AUTO_BLOCK_COMMENT
   Module block: re-uses infrastructure defined elsewhere; pass inputs and capture outputs.
*/
module "compute" {
  source = "./modules/compute"
  ami_id = data.aws_ami.ubuntu.id
}
