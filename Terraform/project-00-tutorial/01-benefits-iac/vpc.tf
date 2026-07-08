/* # AUTO_COMMENT_ADDED
   File: 01-benefits-iac\vpc.tf
   Purpose: Terraform configuration for the '01-benefits-iac' tutorial folder.
   Summary: Networking resources (VPC, subnets, route tables, gateways).
   See project-00-tutorial/readme.md for high-level details.
*/

/*
  Terraform required providers configuration
  - Declares which providers Terraform will download and the version constraints.
*/
/* AUTO_BLOCK_COMMENT
   Terraform settings block: declares required providers and Terraform version constraints.
*/
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

/*
  AWS provider configuration
  - Sets provider-specific settings such as region where resources will be created.
*/
/* AUTO_BLOCK_COMMENT
   Provider configuration: sets provider-specific settings (region, credentials, aliases).
*/
provider "aws" {
  region = "eu-west-1"
}

/*
  VPC resource
  - Creates an AWS VPC with a /16 CIDR block.
  - The `tags` block gives the VPC a human-readable Name for identification.
*/
/* AUTO_BLOCK_COMMENT
   VPC: virtual private cloud that provides an isolated network for resources.

   Block name: demo_vpc
*/
resource "aws_vpc" "demo_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "Terraform VPC"
  }
}

/*
  Public subnet
  - Subnet inside the VPC for resources that need direct internet access.
  - Uses a smaller /24 range carved from the VPC CIDR.
*/
/* AUTO_BLOCK_COMMENT
   Subnet: a CIDR block within a VPC used to place resources (public/private).

   Block name: public_subnet
*/
resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.demo_vpc.id
  cidr_block = "10.0.0.0/24"
}

/*
  Private subnet
  - Subnet inside the VPC intended for internal-only resources.
  - No direct route to the internet by default.
*/
/* AUTO_BLOCK_COMMENT
   Subnet: a CIDR block within a VPC used to place resources (public/private).

   Block name: private_subnet
*/
resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.demo_vpc.id
  cidr_block = "10.0.1.0/24"
}

/*
  Internet Gateway
  - Provides internet connectivity for the VPC when attached to a route table.
*/
/* AUTO_BLOCK_COMMENT
   Internet Gateway: attaches the VPC to the public internet.

   Block name: igw
*/
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.demo_vpc.id
}

/*
  Public route table
  - Contains a default route that sends all outbound traffic to the Internet Gateway.
  - Associate this route table with public subnets to give them internet access.
*/
/* AUTO_BLOCK_COMMENT
   Route Table: contains routes used by subnets for network traffic (e.g., to IGW).

   Block name: public_rtb
*/
resource "aws_route_table" "public_rtb" {
  vpc_id = aws_vpc.demo_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

/*
  Route table association
  - Links the public subnet to the public route table so instances in the subnet use that routing.
*/
/* AUTO_BLOCK_COMMENT
   Route Table Association: links a subnet to a route table so the subnet follows those routes.

   Block name: public_subnet
*/
resource "aws_route_table_association" "public_subnet" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rtb.id
}
