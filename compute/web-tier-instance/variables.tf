variable "alb_dns_name" {
  type = string
}
variable "s3_bucket_name" {
  type = string
}

variable "aws_iam_instance_profile" {
  type = string
}

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

variable "web_tier_sg" {
  type = string
}

variable "aws_vpc_id" {
  type = string
}

variable "internet_lb_sg" {
  type = string
}