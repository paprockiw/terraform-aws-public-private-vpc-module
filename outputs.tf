# Public Subnet IDs
output "public_subnet_ids" {
  value = aws_subnet.public_subnets[*].id
  description = "List of public subnet IDs"
}

output "public_subnet_id_map" {
  value = { for idx, subnet in aws_subnet.public_subnets : "public_subnet_${idx + 1}" => subnet.id }
  description = "Map of public subnet IDs indexed by number"
}

# Private Subnet IDs
output "private_subnet_ids" {
  value = aws_subnet.private_subnets[*].id
  description = "List of private subnet IDs"
}

output "private_subnet_id_map" {
  value = { for idx, subnet in aws_subnet.private_subnets : "private_subnet_${idx + 1}" => subnet.id }
  description = "Map of private subnet IDs indexed by number"
}

# NAT Gateway EIPs
output "nat_eip_ids" {
  value = aws_eip.nat[*].id
  description = "List of Elastic IP IDs for NAT Gateways"
}

output "nat_eip_map" {
  value = { for idx, eip in aws_eip.nat : "nat_eip_${idx + 1}" => eip.public_ip }
  description = "Map of NAT Gateway Elastic IPs by index"
}


# Common security groups
output "sg_public_tls_ingress_id" {
  value = aws_security_group.sg_public_tls_ingress.id
}

output "sg_public_tls_egress_id" {
  value = aws_security_group.sg_public_tls_egress.id
}

output "sg_priv_http_ingress" {
  value = aws_security_group.sg_priv_http_ingress.id
}

output "sg_priv_http_egress" {
  value = aws_security_group.sg_priv_http_egress.id
}

output "sg_allow_all_traffic"{
  value = aws_security_group.sg_allow_all_traffic.id
}
