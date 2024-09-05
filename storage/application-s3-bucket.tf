# bucket to store the application code

resource "random_id" "bucket_suffix" {
  byte_length = 6
}

resource "aws_s3_bucket" "application_bucket" {
  bucket = "${var.application_name}-${random_id.bucket_suffix.hex}"
  tags   = merge(local.tags, { Name = "aws-s3-bucket-${var.application_name}" })
}

# resource "null_resource" "replace_db_config" {
#   provisioner "local-exec" {
#     command = <<EOT
#     sed 's|APP_DB_HOST|${var.db_host}|g; s|APP_DB_USER|${var.db_user}|g; s|APP_DB_PWD|${var.db_pwd}|g; s|APP_DB_DATABASE|${var.db_database}|g; s/\([&()\{\}]\)//g' ${local.path_to_db_config} > /tmp/db_config.tmp
#     mv /tmp/db_config.tmp ${file(local.path_to_db_config)}
#     EOT
#   }
# }

data "local_file" "app_tier_files" {
  # depends_on = [ null_resource.replace_db_config ]
  for_each = fileset(local.path_to_app_code, "*")
  filename = "${local.path_to_app_code}/${each.key}"
}

resource "aws_s3_object" "app_tier_code" {
  for_each = data.local_file.app_tier_files
  bucket   = aws_s3_bucket.application_bucket.bucket
  key      = "application-code/app-tier/${each.key}"
  source   = "${local.path_to_app_code}/${each.key}"
  acl      = "private"
  etag     = filemd5("${local.path_to_app_code}/${each.key}")
}