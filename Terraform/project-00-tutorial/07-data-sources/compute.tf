/* # AUTO_COMMENT_ADDED
   File: 07-data-sources\compute.tf
   Purpose: Terraform configuration for the '07-data-sources' tutorial folder.
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
   Data source: reads information from the provider without creating new resources.

   Block name: current
*/
data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

/* AUTO_BLOCK_COMMENT
   Data source: reads information from the provider without creating new resources.

   Block name: prod_vpc
*/
data "aws_vpc" "prod_vpc" {
  tags = {
    Env = "Prod"
  }
}

/* AUTO_BLOCK_COMMENT
   Data source: reads information from the provider without creating new resources.

   Block name: available
*/
data "aws_availability_zones" "available" {
  state = "available"
}

/* AUTO_BLOCK_COMMENT
   Data source: reads information from the provider without creating new resources.

   Block name: static_website
*/
data "aws_iam_policy_document" "static_website" {
  statement {
    sid = "PublicReadGetObject"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = ["s3:GetObject"]

    resources = ["arn:aws:s3:::*/*"]
  }
}

/* AUTO_BLOCK_COMMENT
   S3 bucket: creates a storage bucket. Often used for static sites, artifacts, or remote state.

   Block name: public_read_bucket
*/
resource "aws_s3_bucket" "public_read_bucket" {
  bucket = "my-public-read-bucket"
}

/* AUTO_BLOCK_COMMENT
   Output: exposes computed values after apply (useful for humans and CI).
*/
output "iam_policy" {
  value = data.aws_iam_policy_document.static_website.json
}

/* AUTO_BLOCK_COMMENT
   Output: exposes computed values after apply (useful for humans and CI).
*/
output "azs" {
  value = data.aws_availability_zones.available
}

/* AUTO_BLOCK_COMMENT
   Output: exposes computed values after apply (useful for humans and CI).
*/
output "prod_vpc_id" {
  value = data.aws_vpc.prod_vpc.id
}

/* AUTO_BLOCK_COMMENT
   Output: exposes computed values after apply (useful for humans and CI).
*/
output "ubuntu_ami_data" {
  value = data.aws_ami.ubuntu.id
}

/* AUTO_BLOCK_COMMENT
   Output: exposes computed values after apply (useful for humans and CI).
*/
output "aws_caller_identity" {
  value = data.aws_caller_identity.current
}

/* AUTO_BLOCK_COMMENT
   Output: exposes computed values after apply (useful for humans and CI).
*/
output "aws_region" {
  value = data.aws_region.current
}

/* AUTO_BLOCK_COMMENT
   EC2 Instance: launches a virtual machine using a chosen AMI and instance type.
   Shows root_block_device configuration and tagging examples.

   Block name: web
*/
resource "aws_instance" "web" {
  # AMI ID NGINX  = ami-0dfee6e7eb44d480b
  ami                         = data.aws_ami.ubuntu.id
  associate_public_ip_address = true
  instance_type               = "t2.micro"

  root_block_device {
    delete_on_termination = true
    volume_size           = 10
    volume_type           = "gp3"
  }
}
