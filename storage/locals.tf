locals {
  tags = {
    Environment = "TEST"
    Project     = "Three-Tier-Project"
    ManagedBy   = "Terraform"
  }
  path_to_app_code  = "/Users/sagar/Documents/Study/AWS/aws-three-tier-web-architecture-workshop/application-code/app-tier"
  path_to_db_config = "/Users/sagar/Documents/Study/AWS/aws-three-tier-web-architecture-workshop/application-code/app-tier/DbConfig.js"
}

