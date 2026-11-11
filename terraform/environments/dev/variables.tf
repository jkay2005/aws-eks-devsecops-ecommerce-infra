variable "aws_account_id" {
  type = string

  validation {
    condition     = can(regex("^[0-9]{12}$", var.aws_account_id))
    error_message = "aws_account_id must contain exactly 12 digits."
  }
}

variable "aws_region" {
  type    = string
  default = "ap-southeast-1"

  validation {
    condition     = var.aws_region == "ap-southeast-1"
    error_message = "The current IAM policy only allows ap-southeast-1."
  }
}

variable "project" {
  type    = string
  default = "aws-eks-devsecops-ecommerce"
}

variable "environment" {
  type    = string
  default = "dev"

  validation {
    condition     = var.environment == "dev"
    error_message = "This root configuration and IAM policy are for dev."
  }
}

variable "vpc_cidr" {
  type    = string
  default = "10.42.0.0/16"
}

variable "availability_zones" {
  type = list(string)
}
