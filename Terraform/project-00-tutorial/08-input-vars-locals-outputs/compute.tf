/* # AUTO_COMMENT_ADDED
   File: 08-input-vars-locals-outputs\compute.tf
   Purpose: Terraform configuration for the '08-input-vars-locals-outputs' tutorial folder.
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

# resource "aws_instance" "compute" {
#   ami           = data.aws_ami.ubuntu.id
#   instance_type = var.ec2_instance_type

#   root_block_device {
#     delete_on_termination = true
#     volume_size           = var.ec2_volume_config.size
#     volume_type           = var.ec2_volume_config.type
#   }

#   tags = merge(local.common_tags, var.additional_tags)
# }
