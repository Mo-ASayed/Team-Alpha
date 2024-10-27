# vpc outputs.tf

output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.tm_vpc.id
}

output "public_subnets" {
  description = "List of public subnet IDs"
  value       = aws_subnet.tm_subnet[*].id
}

output "sg_id" {
  description = "The ID of the Security Group"
  value       = aws_security_group.tm_sg.id
}
