variable "aws_subnets" {
  description = "Map of public and private subnets"
  type        = map(map(list(string)))
}

variable "availability_zone" {
  type = map(string)
}

variable "application_name" {
  type = string
}

variable "aws_managed_roles" {
  type = list(string)
}

variable "flattened_subnets" {
  type = list(object({
    az          = string
    subnet_name = string
    type        = string
  }))
  default = []
}

variable "db_user" {
  type = string
}

variable "db_pwd" {
  type = string
}

variable "db_database" {
  type = string
}