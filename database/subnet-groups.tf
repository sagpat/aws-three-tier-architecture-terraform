resource "aws_db_subnet_group" "this" {
  name        = "three-tier-db-subnet-group"
  description = "Aurora DB Subnet Group"

  subnet_ids = [for idx, subnet in local.db_layer_sn : var.aws_subnet_ids[idx].id]
  tags       = merge(module.tags.tags, { Name = "three-tier-db-subnet-group" })
}