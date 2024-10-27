# alb outputs.tf

output "target_group_arn" {
  description = "The ARN of the target group"
  value       = aws_lb_target_group.tm-tg.arn
}

output "alb_dns_name" {
  description = "The DNS name of the ALB"
  value       = aws_lb.tm-lb.dns_name
}

output "listener_http_arn" {
  description = "The ARN of the HTTP listener"
  value       = aws_lb_listener.listener_http.id
}

output "listener_https_arn" {
  description = "The ARN of the HTTPS listener"
  value       = aws_lb_listener.listener_https.id
}

output "dns_name" {
  description = "The DNS name of the load balancer"
  value       = aws_lb.tm-lb.dns_name # Adjust based on your actual resource name
}


output "zone_id" {
  description = "The zone ID of the load balancer"
  value       = aws_lb.tm-lb.zone_id # Ensure this is the correct reference
}