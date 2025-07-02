# Public network and related resources

# Public subnets (dynamically generated)
resource "aws_subnet" "public_subnets" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[count.index]

  tags = {
    Built-by    = "terraform"
    Environment = var.environment
    Name        = "${var.platform}-${var.environment}-${var.region}-public-${count.index + 1}"
    Tier        = "public"
  }
}

# Public route table for all public subnets
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Built-by    = "terraform"
    Environment = var.environment
    Name        = "${var.platform}-${var.environment}-${var.region}-public-rt"
    Tier        = "public"
  }
}

# Route to public internet
resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

# Public subnet route table associations
resource "aws_route_table_association" "public_rt_assoc" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_rt.id
}


## Network Address Translation Resources
# Elastic IPs to attach to NAT Gateway
resource "aws_eip" "nat" {
  count      = length(var.private_subnet_cidrs)
  domain     = "vpc"
  depends_on = [aws_internet_gateway.igw]

  tags = {
    Built-by    = "terraform"
    Environment = var.environment
    Name        = "${var.platform}-${var.environment}-${var.region}-nat-eip-${count.index + 1}"
    Tier        = "public"
  }
}

# NAT Gateway config
resource "aws_nat_gateway" "nat_gws" {
  count         = length(var.private_subnet_cidrs)
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public_subnets[count.index].id
  tags = {
    Built-by    = "terraform"
    Environment = var.environment
    Name        = "${var.platform}-${var.environment}-${var.region}-nat-${count.index + 1}"
    Tier        = "public"
  }

  depends_on = [aws_internet_gateway.igw]
}

