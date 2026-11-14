terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

variable "repository_name" {
  type = string
}

variable "tags" {
  type = map(string)
}

resource "aws_ecr_repository" "backend" {
  name                 = var.repository_name
  image_tag_mutability = "IMMUTABLE"
  force_delete         = false
  tags                 = var.tags

  encryption_configuration {
    encryption_type = "AES256"
  }
}

output "repository_name" {
  value = aws_ecr_repository.backend.name
}

output "repository_url" {
  value = aws_ecr_repository.backend.repository_url
}
