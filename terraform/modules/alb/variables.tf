# alb variables.tf

variable "alb-name" {
  description = "Name of the ALB"
  type        = string
}

variable "security_group_id" {
  description = "Security Group ID for the ALB"
  type        = string
}

variable "subnet_ids" {
  description = "List of Subnet IDs for the ALB"
  type        = list(string)
}

variable "target-group-name" {
  description = "Name of the target group"
  type        = string
}

variable "target_port" {
  description = "Port for the target group"
  type        = number
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "certificate_arn" {
  description = "The ARN of the SSL certificate for the ALB"
  type        = string
}

