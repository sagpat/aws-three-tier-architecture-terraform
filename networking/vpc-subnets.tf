resource "aws_vpc" "main_vpc" {
  cidr_block = "10.1.0.0/16"

  tags = merge(module.tags.tags, { Name = "aws_main_vpc" })
}

# Subnets
resource "aws_subnet" "subnets" {
  for_each          = { for idx, subnet in var.flattened_subnets : idx => subnet }
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = cidrsubnet(aws_vpc.main_vpc.cidr_block, 8, each.key)
  availability_zone = var.availability_zone[each.value.az]

  tags = merge(module.tags.tags, { Name = each.value.subnet_name })
}