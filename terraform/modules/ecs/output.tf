# ecs outputs.tf

output "cluster_name" {
  description = "The name of the ECS cluster"
  value       = aws_ecs_cluster.tm_cluster.name
}
