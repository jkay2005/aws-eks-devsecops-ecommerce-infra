locals {
  tags = {
    Project     = var.project
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

module "network" {
  source = "../../modules/network"

  name               = "${var.project}-${var.environment}"
  vpc_cidr           = var.vpc_cidr
  availability_zones = var.availability_zones
  tags               = local.tags
}
