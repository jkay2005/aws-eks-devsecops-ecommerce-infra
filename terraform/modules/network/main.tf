locals {
  zones = { for index, az in var.availability_zones : az => index }
}

# https://docs.aws.amazon.com/eks/latest/userguide/network-reqs.html
resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(var.tags, { Name = var.name })
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags   = merge(var.tags, { Name = "${var.name}-igw" })
}

# https://developer.hashicorp.com/terraform/language/functions/cidrsubnet
resource "aws_subnet" "public" {
  for_each = local.zones

  vpc_id                  = aws_vpc.this.id
  availability_zone       = each.key
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, each.value)
  map_public_ip_on_launch = false

  tags = merge(var.tags, {
    Name                     = "${var.name}-public-${each.key}"
    Tier                     = "public"
    "kubernetes.io/role/elb" = "1"
  })
}

resource "aws_subnet" "app" {
  for_each = local.zones

  vpc_id                  = aws_vpc.this.id
  availability_zone       = each.key
  cidr_block              = cidrsubnet(var.vpc_cidr, 4, each.value + 1)
  map_public_ip_on_launch = false

  tags = merge(var.tags, {
    Name                              = "${var.name}-app-${each.key}"
    Tier                              = "app"
    "kubernetes.io/role/internal-elb" = "1"
  })
}

resource "aws_subnet" "data" {
  for_each = local.zones

  vpc_id                  = aws_vpc.this.id
  availability_zone       = each.key
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, each.value + 64)
  map_public_ip_on_launch = false

  tags = merge(var.tags, {
    Name = "${var.name}-data-${each.key}"
    Tier = "data"
  })
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  tags   = merge(var.tags, { Name = "${var.name}-public", Tier = "public" })
}

resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

resource "aws_route_table" "app" {
  for_each = local.zones

  vpc_id = aws_vpc.this.id
  tags   = merge(var.tags, { Name = "${var.name}-app-${each.key}", Tier = "app" })
}

resource "aws_route_table" "data" {
  for_each = local.zones

  vpc_id = aws_vpc.this.id
  tags   = merge(var.tags, { Name = "${var.name}-data-${each.key}", Tier = "data" })
}

resource "aws_route_table_association" "public" {
  for_each = local.zones

  subnet_id      = aws_subnet.public[each.key].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "app" {
  for_each = local.zones

  subnet_id      = aws_subnet.app[each.key].id
  route_table_id = aws_route_table.app[each.key].id
}

resource "aws_route_table_association" "data" {
  for_each = local.zones

  subnet_id      = aws_subnet.data[each.key].id
  route_table_id = aws_route_table.data[each.key].id
}
