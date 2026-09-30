variable "aws_account_id" {
  description = "AWS account that owns the infrastructure."
  type        = string

  validation {
    condition     = can(regex("^[0-9]{12}$", var.aws_account_id))
    error_message = "aws_account_id must contain exactly 12 digits."
  }
}

variable "aws_region" {
  description = "AWS region for the state bucket."
  type        = string
  default     = "ap-southeast-1"

  validation {
    condition     = var.aws_region == "ap-southeast-1"
    error_message = "The current IAM policy permits this bootstrap in ap-southeast-1."
  }
}