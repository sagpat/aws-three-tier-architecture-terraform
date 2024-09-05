# resource "null_resource" "replace_dns_config" {
#   provisioner "local-exec" {
#     command = "sed -i 's/[INTERNAL_LB_DNS]/${var.db_host}/g' ${local.path_to_web_server}"
#   }
# }

# Upload the web server code to S3
data "local_file" "app_tier_files" {
  #   depends_on = [ null_resource.replace_db_config ]
  for_each = fileset(local.path_to_web_code, "**")
  filename = "${local.path_to_web_code}/${each.key}"
}

resource "aws_s3_object" "web_tier_code" {
  for_each = data.local_file.app_tier_files
  bucket   = var.s3_bucket_name
  key      = "application-code/web-tier/${each.key}"
  source   = "${local.path_to_web_code}/${each.key}"
  acl      = "private"
  etag     = filemd5("${local.path_to_web_code}/${each.key}")
}

resource "aws_s3_object" "nginx_file_upload" {
  for_each = data.local_file.app_tier_files
  bucket   = var.s3_bucket_name
  key      = "application-code/web-tier/nginx.conf"
  source   = local.path_to_web_server
  acl      = "private"
  etag     = filemd5(local.path_to_web_server)
}