output "aws_nat_gateway" {
  value = { for key, ngw in module.networking.aws_nat_gateway : key => ngw.id }
}


output "aws_route_table_app" {
  value = { for key, value in module.networking.aws_route_table_app : key => value }
}

output "aws_route_table_web" {
  value = { for key, value in module.networking.aws_route_table_web : key => value }
}

output "web_layer_sn" {
  value = module.networking.web_layer_sn
}

output "app_layer_sn" {
  value = module.networking.app_layer_sn
}

output "aws_subnet_ids" {
  value = { for key, value in module.networking.aws_subnet_ids : key => value }
}

output "db_sg" {
  value = module.networking.db_sg
}

output "aws_iam_instance_profile" {
  value = module.iam_roles.aws_iam_instance_profile
}

output "private_instance_sg" {
  value = module.networking.private_instance_sg
}

output "mysql_writer_endpoint" {
  value = module.database.mysql_writer_endpoint
}

output "aws_rds_cluster_endpoint" {
  value = module.database.aws_rds_cluster_endpoint
}

output "s3_bucket_name" {
  value = module.storage.s3_bucket_name
}

output "aws_vpc_id" {
  value = module.networking.aws_vpc_id.id
}