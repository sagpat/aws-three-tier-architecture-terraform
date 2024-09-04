# Route for public subnets with internet connectivity
resource "aws_route_table" "web_layer" {
  vpc_id = aws_vpc.main_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.aws_main_igw.id
  }

  tags = merge(module.tags.tags, { Name = "aws_main_route_table" })
}

resource "aws_route_table_association" "web_subnet_association" {
  for_each       = local.web_layer_sn
  subnet_id      = aws_subnet.subnets[each.key].id
  route_table_id = aws_route_table.web_layer.id
}

# Routes for app layer subnets in each az.
# These route tables will route app layer traffic destined for outside the VPC to the NAT gateway in the respective availability zone.
resource "aws_route_table" "app_layer" {
  for_each = aws_nat_gateway.natgw
  vpc_id   = aws_vpc.main_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = each.value.id
  }

  tags = merge(module.tags.tags, { Name = "aws_rt-${each.value.id}" })
}

// refactor this code to get the values dynamically
resource "aws_route_table_association" "app_az1_subnet_association" {
  subnet_id      = aws_subnet.subnets[0].id
  route_table_id = aws_route_table.app_layer[4].id
}

resource "aws_route_table_association" "app_az2_subnet_association" {
  subnet_id      = aws_subnet.subnets[2].id
  route_table_id = aws_route_table.app_layer[5].id
}