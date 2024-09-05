aws_subnets = {
  public_subnet = {
    az1 = ["public-web-subnet-az1"]
    az2 = ["public-web-subnet-az2"]
  }
  private_subnet = {
    az1 = ["private-app-subnet-az1", "private-db-subnet-az1"]
    az2 = ["private-app-subnet-az2", "private-db-subnet-az2"]
  }
}

availability_zone = {
  az1 = "us-west-2a"
  az2 = "us-west-2b"
}

application_name = "three-tier-app"

aws_managed_roles = [
  "AmazonSSMManagedInstanceCore",
  "AmazonS3ReadOnlyAccess"
]

# Database details - Enhancement: TO GET IT FROM SECRETS MANAGER 
db_user     = "admin"
db_pwd      = "yuYBuFGSKLVG"
db_database = "webappdb_data1"
