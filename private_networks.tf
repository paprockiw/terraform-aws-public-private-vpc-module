
# Dynamically generate private subnets from CIDR array
resource "aws_subnet" "private_subnets" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Built-by    = "terraform"
    Environment = var.environment
    Name        = "${var.platform}-${var.environment}-${var.region}-private-${count.index + 1}"
    Tier        = "private"
  }

  depends_on = [aws_nat_gateway.nat_gws]
}

# Dynamically generate private route tables
resource "aws_route_table" "private_rts" {
  count  = length(var.private_subnet_cidrs)
  vpc_id = aws_vpc.vpc.id

  tags = {
    Built-by    = "terraform"
    Environment = var.environment
    Name        = "${var.platform}-${var.environment}-${var.region}-private-rt-${count.index + 1}"
    Tier        = "private"
  }

  depends_on = [aws_nat_gateway.nat_gws]
}

# Generate routes to NAT GW in route tables
resource "aws_route" "private_nat_gateway_routes" {
  count                  = length(var.private_subnet_cidrs)
  route_table_id         = aws_route_table.private_rts[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gws[count.index].id

  depends_on = [aws_nat_gateway.nat_gws]
}

# Associate routes for NAT GW to private subnets
resource "aws_route_table_association" "private" {
  count          = length(var.private_subnet_cidrs)
  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.private_rts[count.index].id

  depends_on = [aws_route.private_nat_gateway_routes]
}

