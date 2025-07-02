## VPC & IGW setup

data "aws_availability_zones" "available" {
  state = "available"
}

# VPC 
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Environment = var.environment
    Name = "${var.platform}-${var.environment}-vpc"
    built_by = "terraform"
    platform = var.platform
  }
}

# Internet Gateway for VPC
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Environment = var.environment
    Name = "${var.platform}-${var.environment}-vpc-igw"
    built_by = "terraform"
    platform = var.platform
  }
}
