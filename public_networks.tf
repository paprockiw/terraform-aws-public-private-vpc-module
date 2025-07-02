# Public network and related resources

data "aws_availability_zones" "available" {
  state = "available"
}

# Public subnets (dynamically generated)
resource "aws_subnet" "public_subnets" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[count.index]

  tags = {
    Environment = var.environment
    Name        = "${var.platform}-${var.environment}-${var.region}-public-${count.index + 1}"
    Tier        = "public"
    built_by    = "terraform"
  }
}

# Public route table for all public subnets
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.platform}-${var.environment}-${var.region}-public-rt"
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

