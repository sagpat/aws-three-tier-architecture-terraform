variable "aws_subnets" {
  description = "Map of public and private subnets"
  type        = map(map(list(string)))
}

variable "availability_zone" {
  type = map(string)
}

variable "flattened_subnets" {
  type = list(object({
    az          = string
    subnet_name = string
    type        = string
  }))
  default = []
}
