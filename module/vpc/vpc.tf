###################
# VPC
###################
resource "aws_vpc" "main" {
  cidr_block = var.cidr_block
  tags = merge(
    {
      "Name" = format("%s%s", var.name, "VPC")
    },
    var.tags,
  )
}


################
# Private subnet
################
resource "aws_subnet" "private" {
  for_each          = var.private_subnets
  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value
  availability_zone = var.private_azs[each.key]
  tags = merge(
    {
      "Name" = format("%s%s", var.name, each.key)
    },
    var.tags,
  )
}


################
# Public subnet
################
resource "aws_subnet" "public" {
  for_each                = var.public_subnets
  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value
  availability_zone       = var.public_azs[each.key]
  map_public_ip_on_launch = "true"
  tags = merge(
    {
      "Name" = format("%s%s", var.name, each.key)
    },
    var.tags,
  )
}


###################
# Internet Gateway
###################
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    {
      "Name" = format("%s%s", var.name, "IGW")
    },
    var.tags,
  )
}

################################################
# Add a route to internet via igw (public route)
################################################
resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = var.cidr_block_destination
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = merge(
    {
      "Name" = format("%s%s", var.name, "PublicRouteTable")
    },
    var.tags,
  )
}


############################################
# Associate public route with public subnets
############################################
resource "aws_route_table_association" "public-subnet-association" {
  for_each       = aws_subnet.public
  subnet_id      = aws_subnet.public[each.key].id
  route_table_id = aws_route_table.public-route-table.id
}


############################
# Elastic ip for nat gateway
############################
resource "aws_eip" "eip" {
  for_each = var.public_subnets
  vpc      = var.eip_vpc
  tags = merge(
    {
      "Name" = format("%s%s", var.name, "EIP")
    },
    var.tags,
  )
}


##############
# NAT Gateway
##############

locals {
  # create a list from eip and private/[ublic subnets maps
  eip = [
    for r in aws_eip.eip : r.id
  ]

  private_subnet_id = [
    for r in aws_subnet.private : r.id
  ]

  public_subnet_id = [
    for r in aws_subnet.public : r.id
  ]
}

# create nat gateway for each private subnet
resource "aws_nat_gateway" "nat-gw" {
  count = length(var.private_subnets)

  allocation_id = local.eip[count.index]
  subnet_id     = local.public_subnet_id[count.index]

  depends_on = [aws_internet_gateway.igw]
  tags = merge(
    {
      "Name" = format("%s%s", var.name, "NATGW")
    },
    var.tags,
  )
}


#####################################################
# Add a route to internet via nat gw (private route)
#####################################################
resource "aws_route_table" "private-route-table" {
  count  = length(var.private_subnets)
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = var.cidr_block_destination
    nat_gateway_id = aws_nat_gateway.nat-gw[count.index].id
  }

  tags = merge(
    {
      "Name" = format("%s%s%d", var.name, "PrivateRouteTable", count.index + 1)
    },
    var.tags,
  )
}


###############################################
# Aassociate private route with private subnets
################################################
resource "aws_route_table_association" "private-subnet-association" {
  count          = length(var.private_subnets)
  subnet_id      = local.private_subnet_id[count.index]
  route_table_id = aws_route_table.private-route-table[count.index].id
}

