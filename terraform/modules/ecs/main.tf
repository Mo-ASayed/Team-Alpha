# ECS Cluster
resource "aws_ecs_cluster" "tm_cluster" {
  name = var.cluster_name
}

# ECS Task Definition
resource "aws_ecs_task_definition" "tm_task" {
  family                   = var.task_family
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.task_cpu
  memory                   = var.task_memory
  execution_role_arn       = var.execution_role_arn
  task_role_arn            = var.task_role_arn
  container_definitions    = <<DEFINITION
[
  {
    "name": "${var.container_name}",
    "image": "${var.container_image}",
    "cpu": ${var.task_cpu},
    "memory": ${var.task_memory},
    "essential": true,
    "portMappings": [
      {
        "containerPort": ${var.container_port},
        "hostPort": ${var.container_port},
        "protocol": "tcp"
      }
    ]
  }
]
DEFINITION
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "ARM64"
  }
}

# ECS Service
resource "aws_ecs_service" "tm_service" {
  name            = var.service_name
  cluster         = aws_ecs_cluster.tm_cluster.id
  task_definition = aws_ecs_task_definition.tm_task.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.subnet_ids
    security_groups  = var.security_group_ids
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = var.container_name
    container_port   = var.container_port
  }
  deployment_controller {
    type = "ECS"

  }
  depends_on = [var.listener_http_arn, var.listener_https_arn]
}

# Conditionally create IAM Role if needed
resource "aws_iam_role" "ecs_task_execution_role" {
  count = var.create_iam_role ? 1 : 0
  name  = var.iam_role_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Effect = "Allow"
        Sid    = ""
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_execution_policy" {
  count      = var.create_iam_role ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  role       = aws_iam_role.ecs_task_execution_role[0].name
}
