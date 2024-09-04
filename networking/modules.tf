module "tags" {
  source    = "../modules/tagging"
  base_tags = local.tags
}