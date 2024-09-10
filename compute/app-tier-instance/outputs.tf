output "app_instance_user_data" {
  value = aws_instance.app_tier_instance.user_data
}

output "app_tier_instance_id" {
  value = aws_instance.app_tier_instance.id
}

