locals {
  tags = {
    Environment = "TEST"
    Project     = "Three-Tier-Project"
    ManagedBy   = "Terraform"
  }

  app_layer_sn = {
    for idx, subnet in var.flattened_subnets :
    idx => subnet.subnet_name
    if(subnet.subnet_name == "private-app-subnet-az1" || subnet.subnet_name == "private-app-subnet-az2")
  }

  private_app_index_az1 = keys(local.app_layer_sn)[0]
  private_app_index_az2 = keys(local.app_layer_sn)[1]

  app_subet_ids = [var.aws_subnet_ids[local.private_app_index_az1].id,
  var.aws_subnet_ids[local.private_app_index_az2].id]
}