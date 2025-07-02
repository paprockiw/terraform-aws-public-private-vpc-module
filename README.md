# VPC Terraform Module

This will build a VPC environment in AWS, including the following resources:

- A VPC, based on a user-provided CIDR block.
- Public and private subnets based on user-defined CIDR blocks.
- Subnets are placed in different availability zones (AZs) for redunancy.
- An Internet Gateway egress to the public internet.
- NAT Gateways in each public subnet in different AZs for redundancy.
- Route tables and route associations for each subnet.
- Tagging for all resources with consistent naming.

---

## Usage for this module

```hcl
module "vpc" {
  source              = "./vpc-module"

  account_num         = "123456789012"
  platform            = "application-name"
  environment         = "dev"
  region              = "us-east-1"
  vpc_cidr            = "10.0.0.0/20"

  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]
}

