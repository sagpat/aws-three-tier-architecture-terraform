locals {
  flattened_subnets = flatten([
    for subnet_type, az_map in var.aws_subnets : [
      for az, subnets in az_map : [
        for subnet in subnets : {
          az          = az
          subnet_name = subnet
          type        = subnet_type
        }
      ]
    ]
  ])
}