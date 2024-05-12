resource "aws_vpc" "vpc1" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    "Name" = var.vpc_name
  }
}

resource "aws_subnet" "pubsubnet1" {
  vpc_id                  = aws_vpc.vpc1.id
  cidr_block              = var.pub_cidr
  map_public_ip_on_launch = true
  availability_zone       = var.pub_cidr_az

  tags = {
    "Name" = var.pub_cidr_name
  }
}

resource "aws_subnet" "privsubnet1" {
  vpc_id                  = aws_vpc.vpc1.id
  cidr_block              = var.priv_cidr
  map_public_ip_on_launch = false
  availability_zone       = var.priv_cidr_az

  tags = {
    "Name" = var.priv_cidr_name
  }
}

resource "aws_internet_gateway" "tfigw" {
  vpc_id = aws_vpc.vpc1.id

  tags = {
    Name = var.ig_name
  }
}

resource "aws_route_table" "pub_rt" {
  vpc_id = aws_vpc.vpc1.id

  route {
    cidr_block = var.pub_route_cidr
    gateway_id = aws_internet_gateway.tfigw.id
  }
}

resource "aws_route_table_association" "pub_rta" {
  subnet_id      = aws_subnet.pubsubnet1.id
  route_table_id = aws_route_table.pub_rt.id
}

resource "aws_nat_gateway" "tfngw" {
  subnet_id         = aws_subnet.privsubnet1.id
  connectivity_type = "private"

  tags = {
    Name = var.ng_name
  }
}

resource "aws_route_table" "priv_rt" {
  vpc_id = aws_vpc.vpc1.id
  route {
    cidr_block     = var.vpc_cidr
    nat_gateway_id = aws_nat_gateway.tfngw.id
  }
}

resource "aws_route_table_association" "priv_rta" {
  subnet_id      = aws_subnet.privsubnet1.id
  route_table_id = aws_route_table.priv_rt.id
}

