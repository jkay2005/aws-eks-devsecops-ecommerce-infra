output "state_bucket_name" {
  description = "S3 bucket used for Terraform state."
  value       = aws_s3_bucket.state.id
}

output "aws_account_id" {
  description = "AWS account that owns the state bucket."
  value       = var.aws_account_id
}

output "aws_region" {
  description = "Region containing the state bucket."
  value       = var.aws_region
}