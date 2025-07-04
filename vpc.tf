## VPC & IGW setup

data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  vpc_name =  "${var.platform}-${var.environment}-vpc"
}

# VPC 
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Built-by    = "terraform"
    Environment = var.environment
    Name        = local.vpc_name
    Tier        = "public"
  }
}

# Internet Gateway for VPC
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Built-by    = "terraform"
    Environment = var.environment
    Name        = "${var.platform}-${var.environment}-vpc-igw"
    Tier        = "public"
  }
}
