module "ecr" {
  source = "../../modules/ecr"

  repository_name = "${var.project}/backend"
  tags            = local.tags
}

output "ecr_repository_name" {
  value = module.ecr.repository_name
}

output "ecr_repository_url" {
  value = module.ecr.repository_url
}
