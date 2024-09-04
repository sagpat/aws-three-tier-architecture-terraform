# Internet Gateway
resource "aws_internet_gateway" "aws_main_igw" {
  vpc_id = aws_vpc.main_vpc.id
  tags   = merge(module.tags.tags, { Name = "aws-main-igw" })
}

# NAT Gateway
resource "aws_eip" "nat" {
  for_each = local.web_layer_sn

  domain = "vpc"
  tags   = merge(module.tags.tags, { Name = "aws-eip" })
}

resource "aws_nat_gateway" "natgw" {
  for_each      = local.web_layer_sn
  allocation_id = aws_eip.nat[each.key].id
  subnet_id     = aws_subnet.subnets[each.key].id

  tags = merge(module.tags.tags, { Name = "aws-nat-gateway-${each.value}" })
}