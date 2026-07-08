/* # AUTO_COMMENT_ADDED
   File: 18-terraform-cloud\compute.tf
   Purpose: Terraform configuration for the '18-terraform-cloud' tutorial folder.
   Summary: Contains compute/EC2 resource examples (instances, root_block_device, tags).
   See project-00-tutorial/readme.md for high-level details.
*/

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

   Block name: tf_cloud
*/
resource "aws_instance" "tf_cloud" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.ec2_instance_type

  tags = {
    Name = "terraform-cloud"
  }
}
