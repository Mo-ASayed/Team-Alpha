# ecs variables.tf

variable "cluster_name" {
  description = "Name of the ECS Cluster"
  type        = string
}

variable "task_family" {
  description = "Family of the ECS Task"
  type        = string
}

variable "task_cpu" {
  description = "CPU units for the ECS Task"
  type        = string
}

variable "task_memory" {
  description = "Memory (MiB) for the ECS Task"
  type        = string
}

variable "container_name" {
  description = "Name of the container"
  type        = string
}

variable "container_image" {
  description = "Container image for ECS Task"
  type        = string
}

variable "container_port" {
  description = "Container port for the application"
  type        = number
}

variable "service_name" {
  description = "Name of the ECS Service"
  type        = string
}

variable "desired_count" {
  description = "Desired count of ECS Service instances"
  type        = number
}

variable "subnet_ids" {
  description = "List of Subnet IDs for ECS Service"
  type        = list(string)
}

variable "security_group_ids" {
  description = "List of Security Group IDs for ECS Service"
  type        = list(string)
}

variable "target_group_arn" {
  description = "Target Group ARN for the ECS Service"
  type        = string
}

variable "execution_role_arn" {
  description = "Execution role ARN for ECS Task"
  type        = string
}

variable "task_role_arn" {
  description = "The IAM role ARN to use for the ECS Task"
  type        = string
}

variable "create_iam_role" {
  description = "iam role name"
  type        = string
}
variable "iam_role_name" {
  description = "role name "
  type        = string
}

variable "listener_http_arn" {
  description = "http listner"
  type        = string

}
variable "listener_https_arn" {
  description = "https listner"
  type        = string
}