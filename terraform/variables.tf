# variables.tf

variable "region" {
  description = "The AWS region to deploy into"
  default     = "eu-west-2"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "availability_zones" {
  description = "List of availability zones for the VPC"
  type        = list(string)
  default     = ["eu-west-2a", "eu-west-2b"]
}

variable "sg_name" {
  description = "Name of the Security Group"
  default     = "tm_security_group"
}

variable "alb-name" {
  description = "Name of the ALB"
  default     = "tm-lb"
}

variable "target-group-name" {
  description = "Name of the target group"
  default     = "tm-target-group"
}

variable "container_image" {
  description = "Container image for ECS task"
  default     = "992382674979.dkr.ecr.eu-west-2.amazonaws.com/threatmodelapp2:latest"
}

variable "container_port" {
  description = "Container port for the application"
  default     = 3000
}

variable "desired_count" {
  description = "Desired count of ECS service instances"
  default     = 1
}

variable "certificate_arn" {
  description = "The ARN of the SSL certificate for the ALB"
  default     = "arn:aws:acm:eu-west-2:992382674979:certificate/b40264cc-cf86-4cab-892d-6c41219358c0"
}

variable "zone_name" {
  description = "Route53 zone name"
  default     = "tm.teamalpha.abdelhakimyusuf.net"
}

variable "record_name" {
  description = "Route53 record name"
  default     = "tm.teamalpha.abdelhakimyusuf.net"
}


variable "task_role_arn" {
  description = "The IAM role ARN to use for the ECS Task"
  type        = string
  default     = "arn:aws:iam::992382674979:role/ecsTaskExecutionRole"
}

variable "create_iam_role" {
  description = "create iam role"
  type        = bool
  default     = false

}

variable "iam_role_name" {
  description = "role name "
  type        = string
  default     = "ecs_task_execution_role"
}

