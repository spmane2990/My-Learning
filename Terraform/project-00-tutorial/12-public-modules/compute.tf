/* # AUTO_COMMENT_ADDED
   File: 12-public-modules\compute.tf
   Purpose: Terraform configuration for the '12-public-modules' tutorial folder.
   Summary: Contains compute/EC2 resource examples (instances, root_block_device, tags).
   See project-00-tutorial/readme.md for high-level details.
*/

locals {
  instance_type = "t2.micro"
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
   Module block: re-uses infrastructure defined elsewhere; pass inputs and capture outputs.
*/
module "ec2" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.6.1"

  name                   = local.project_name
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = local.instance_type
  vpc_security_group_ids = [module.vpc.default_security_group_id]
  subnet_id              = module.vpc.public_subnets[0]

  tags = local.common_tags
}
