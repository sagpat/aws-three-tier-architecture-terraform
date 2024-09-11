resource "null_resource" "replace_dns_config" {
  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
     command     = <<EXE
     sed 's|DNS_HOST|${var.alb_dns_name}|g' \
     ${local.path_to_web_server} > /tmp/dns_config.tmp && mv /tmp/dns_config.tmp ${local.path_to_web_server}
EXE
  }
}

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
  # etag     = filemd5("${local.path_to_web_code}/${each.key}")
}

resource "aws_s3_object" "nginx_file_upload" {
  for_each = data.local_file.app_tier_files
  bucket   = var.s3_bucket_name
  key      = "application-code/web-tier/nginx.conf"
  source   = local.path_to_web_server
  acl      = "private"
  # etag     = filemd5(local.path_to_web_server)
}