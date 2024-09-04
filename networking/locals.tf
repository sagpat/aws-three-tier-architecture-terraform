locals {
  tags = {
    Environment = "TEST"
    Project     = "Three-Tier-Project"
    ManagedBy   = "Terraform"
  }

  web_layer_sn = {
    for idx, subnet in var.flattened_subnets :
    idx => subnet.subnet_name
    if(subnet.subnet_name == "public-web-subnet-az1" || subnet.subnet_name == "public-web-subnet-az2")
  }

  app_layer_sn = {
    for idx, subnet in var.flattened_subnets :
    idx => subnet.subnet_name
    if(subnet.subnet_name == "private-app-subnet-az1" || subnet.subnet_name == "private-app-subnet-az2")
  }
}