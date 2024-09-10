locals {
  tags = {
    Environment = "TEST"
    Project     = "Three-Tier-Project"
    ManagedBy   = "Terraform"
  }
  path_to_web_server = "/Users/sagar/Documents/Study/AWS/aws-three-tier-web-architecture-workshop/application-code/nginx.conf"
  path_to_web_code   = "/Users/sagar/Documents/Study/AWS/aws-three-tier-web-architecture-workshop/application-code/web-tier"

  app_layer_sn = {
    for idx, subnet in var.flattened_subnets :
    idx => subnet.subnet_name
    if(subnet.subnet_name == "public-web-subnet-az1" || subnet.subnet_name == "public-web-subnet-az2")
  }

  public_web_index_az1 = keys(local.app_layer_sn)[0]
  public_web_index_az2 = keys(local.app_layer_sn)[1]

  web_subet_ids = [var.aws_subnet_ids[local.public_web_index_az1].id,
  var.aws_subnet_ids[local.public_web_index_az2].id]
}