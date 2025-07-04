## Security Groups

resource "aws_security_group" "sg_public_tls_ingress" {
  name        = "public-tls-ingress-sg-${local.vpc_name}"
  description = "Allow public inbound TLS traffic"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description      = "TLS to VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Built-by    = "terraform"
    Environment = "${var.environment}"
    Name        = "public-tls-ingress-sg-${local.vpc_name}"
    Tier        = "public"
  }
}

resource "aws_security_group" "sg_public_tls_egress" {
  name        = "public-tls-egress-sg-${local.vpc_name}"
  description = "Allow public outbound TLS traffic"
  vpc_id      = aws_vpc.vpc.id

  egress {
    description      = "TLS from VPC"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Built-by    = "terraform"
    Environment = "${var.environment}"
    Name        = "public-tls-egress-sg-${local.vpc_name}"
    Tier        = "public"
  }
}

resource "aws_security_group" "sg_priv_http_ingress" {
  name        = "priv-http-ingress-sg-${local.vpc_name}"
  description = "Allow inbound HTTP traffic on VPC CIDR block."
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description      = "TLS to VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = [var.vpc_cidr]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Built-by    = "terraform"
    Environment = "${var.environment}"
    Name        = "priv-http-ingress-sg-${local.vpc_name}"
    Tier        = "private"
  }
}

resource "aws_security_group" "sg_priv_http_egress" {
  name        = "priv-http-egress-sg-${local.vpc_name}"
  description = "Allow outbound HTTP traffic on VPC CIDR block."
  vpc_id      = aws_vpc.vpc.id

  egress {
    description      = "TLS from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = [var.vpc_cidr]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Built-by    = "terraform"
    Environment = "${var.environment}"
    Name        = "priv-http-egress-sg-${local.vpc_name}"
    Tier        = "private"
  }
}

resource "aws_security_group" "sg_allow_all_traffic" {
  name        = "allow-all-traffic-sg-${local.vpc_name}"
  description = "Allow traffic on all ports to/from resources with this security group."
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = -1
    cidr_blocks      = []
    ipv6_cidr_blocks = []
    self             = true
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = -1
    cidr_blocks      = []
    ipv6_cidr_blocks = []
    self             = true
  }

  tags = {
    Built-by    = "terraform"
    Environment = "${var.environment}"
    Name        = "allow-all-traffic-sg-${local.vpc_name}"
    Tier        = "private"
  }
}
