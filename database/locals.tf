locals {
  tags = {
    Environment = "TEST"
    Project     = "Three-Tier-Project"
    ManagedBy   = "Terraform"
  }

  db_layer_sn = {
    for idx, subnet in var.flattened_subnets :
    idx => subnet
    if(subnet.subnet_name == "private-db-subnet-az1" || subnet.subnet_name == "private-db-subnet-az2")
  }
}