# VPC Terraform Module

This will build a VPC environment in AWS, including the following resources:

- A VPC, based on a user-provided CIDR block.
- Public and private subnets based on user-defined CIDR blocks.
- Subnets are placed in different availability zones (AZs) for redunancy.
- An Internet Gateway egress to the public internet.
- NAT Gateways in each public subnet in different AZs for redundancy.
- Route tables and route associations for each subnet.
- Tagging for all resources with consistent naming.
- Flow logs for the VPC. 

## Table of Contents

- [Usage](#usage)
- [Input Variables](#input-variables)
- [Outputs](#outputs)
- [Example Network Diagram](#example-network-diagram)
- [Notes](#notes)

---

## Usage
In a separate location (not within this module), set up a .tf file to invoke 
this module. Configure it following this example:

```hcl
module "vpc" {
  source              = "<path-to-module>/vpc-module"

  account_num         = "123456789012"
  platform            = "application-name"
  environment         = "dev"
  region              = "us-east-1"
  vpc_cidr            = "10.0.0.0/20"

  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]
}
```

---

## Input Variables
| Name                   | Type           | Description                                             |
| ---------------------- | -------------- | ------------------------------------------------------- |
| `account_num`          | `number`       | AWS account number                                      |
| `platform`             | `string`       | Name of the platform/project                            |
| `environment`          | `string`       | Deployment environment (`dev`, `staging`, `prod`, etc.) |
| `region`               | `string`       | AWS region to deploy the resources                      |
| `vpc_cidr`             | `string`       | CIDR block for the VPC                                  |
| `public_subnet_cidrs`  | `list(string)` | List of CIDRs for public subnets                        |
| `private_subnet_cidrs` | `list(string)` | List of CIDRs for private subnets                       |


## Outputs
| Output Name             | Description                                         |
| ----------------------- | --------------------------------------------------- |
| `public_subnet_ids`     | List of all public subnet IDs                       |
| `public_subnet_id_map`  | Map of public subnet IDs indexed by number          |
| `private_subnet_ids`    | List of all private subnet IDs                      |
| `private_subnet_id_map` | Map of private subnet IDs indexed by number         |
| `nat_eip_ids`           | List of Elastic IP IDs allocated for NAT Gateways   |
| `nat_eip_map`           | Map of NAT Gateway EIP public IPs indexed by number |

---

## Example Network Diagram
This is an example of a 2-subnet network that straddles two availability zones (AZ).
This shows how traffic flows to the VPC. Requests come through the IGW, to a public 
subnet, and then packets destined for resources in private resources are sent through 
the NAT Gateway, and to resources in the private subnets. 

                             VPC              
                         (10.0.0.0/16)         
    
    
                        public internet
                              │
                   ┌──────────▼──────────┐
                   │   Internet Gateway  │
                   └───────┬───────┬─────┘
                           │       │
                 ┌─────────▼─┐ ┌───▼────────┐
                 │Public AZ1 │ │ Public AZ2 │
                 │10.0.1.0/24│ │ 10.0.2.0/24│
                 └────┬──────┘ └────┬───────┘
                      │             │
              ┌───────▼─────┐ ┌─────▼────────┐
              │ NAT GW AZ1  │ │ NAT GW AZ2   │
              └──────┬──────┘ └──────┬───────┘
                     │               │
            ┌────────▼──────┐ ┌──────▼────────┐
            │ Private AZ1   │ │ Private AZ2   │
            │ 10.0.101.0/24 │ │ 10.0.102.0/24 │
            └───────────────┘ └───────────────┘
    
---

## Notes
The module dynamically supports any number of AZs/subnets by length of the CIDR lists.
NAT Gateways are provisioned per private subnet for zone isolation and failover.
Subnet and EIP outputs are returned both as flat lists and as indexed maps for flexible downstream use.
