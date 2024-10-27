# route53 variables.tf

variable "zone_name" {
  description = "Route53 zone name"
  type        = string
}

variable "record_name" {
  description = "Route53 record name"
  type        = string
}

variable "alb_dns_name" {
  description = "The DNS name of the ALB to point the Route53 record to"
  type        = string
}

variable "lb_dns_name" {
  description = "The DNS name of the load balancer"
  type        = string
}

variable "lb_zone_id" {
  description = "The zone ID of the load balancer"
  type        = string
}
