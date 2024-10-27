# outputs.tf

output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "alb_dns_name" {
  description = "The DNS name of the ALB"
  value       = module.alb.alb_dns_name
}

output "ecs_cluster_name" {
  description = "The name of the ECS cluster"
  value       = module.ecs.cluster_name
}
output "listener_http" {
  value = module.alb.listener_http_arn # Corrected to match alb output name
}

output "listener_https" {
  value = module.alb.listener_https_arn # Corrected to match alb output name
}

