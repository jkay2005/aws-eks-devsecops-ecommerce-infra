output "vpc_id" {
  value = aws_vpc.this.id
}

output "public_subnet_ids" {
  value = { for az, subnet in aws_subnet.public : az => subnet.id }
}

output "app_subnet_ids" {
  value = { for az, subnet in aws_subnet.app : az => subnet.id }
}

output "data_subnet_ids" {
  value = { for az, subnet in aws_subnet.data : az => subnet.id }
}
