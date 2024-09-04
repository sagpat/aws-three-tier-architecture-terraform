variable "flattened_subnets" {
  type = list(object({
    az          = string
    subnet_name = string
    type        = string
  }))
  default = []
}

variable "aws_subnet_ids" {
  description = "Map of subnet objects"
  type = map(object({
    arn                             = string
    assign_ipv6_address_on_creation = bool
    availability_zone               = string
    cidr_block                      = string
    id                              = string
    map_public_ip_on_launch         = bool
    owner_id                        = string
    tags                            = map(string)
    vpc_id                          = string
  }))
}

variable "db_security_group" {
  description = "database security group"
  type        = string
}

variable "db_user" {
  type = string
}

variable "db_pwd" {
  type = string
}