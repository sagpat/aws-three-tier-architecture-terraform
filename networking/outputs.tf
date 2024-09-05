output "aws_nat_gateway" {
  value = { for key, ngw in aws_nat_gateway.natgw : key => ngw }
}


output "aws_route_table_app" {
  value = { for key, value in aws_route_table.app_layer : key => value }
}

output "aws_route_table_web" {
  value = { for key, value in aws_route_table.web_layer : key => value }
}

output "web_layer_sn" {
  value = local.web_layer_sn
}

output "app_layer_sn" {
  value = local.app_layer_sn
}

output "aws_subnet_ids" {
  value = { for idx, subnet in aws_subnet.subnets : idx => subnet }
}

output "db_sg" {
  value = aws_security_group.db_sg
}

output "private_instance_sg" {
  value = aws_security_group.private_instance_sg
}

output "web_tier_sg" {
  value = aws_security_group.web_tier_sg
}

output "aws_vpc_id" {
  value = aws_vpc.main_vpc
}

output "internal_lb_sg" {
  value = aws_security_group.internal_lb_sg
}

output "internet_lb_sg" {
  value = aws_security_group.sg_internet_facing_lb
}
