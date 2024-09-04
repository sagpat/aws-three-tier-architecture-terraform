variable "base_tags" {
  type = map(string)
}

variable "extra_tags" {
  type    = map(string)
  default = {}
}

output "tags" {
  value = merge(var.base_tags, var.extra_tags)
}