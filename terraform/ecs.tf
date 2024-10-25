# Create ECS Cluster
resource "aws_ecs_cluster" "tmmodel" {
  name = "tmmodel"
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}
# Create ECS Task Definition
resource "aws_ecs_task_definition" "threatmodeltask" {
  family                   = "threatmodeltask"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 1024
  memory                   = 2048
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn # Add execution role
  container_definitions    = <<TASK_DEFINITION
[
  {
    "name": "threatmodel",
    "image": "992382674979.dkr.ecr.eu-west-2.amazonaws.com/threatmodelapp:latest",
    "cpu": 1024,
    "memory": 2048,
    "essential": true,
    "portMappings": [
      {
        "containerPort": 3000,
        "hostPort": 3000,
        "protocol": "tcp"
      }
    ]
  }
]
TASK_DEFINITION
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "ARM64"
  }
}
# Create ECS Service
resource "aws_ecs_service" "tm_service" {
  name            = "tm_service"
  cluster         = aws_ecs_cluster.tmmodel.arn
  task_definition = aws_ecs_task_definition.threatmodeltask.arn
  desired_count   = 3
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [aws_subnet.tm_subnet1.id, aws_subnet.tm_subnet2.id]
    security_groups  = [aws_security_group.tm_ecs_sg.id]
    assign_public_ip = true
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.tm_target_group.arn
    container_name   = "threatmodel"
    container_port   = 3000 # Forwarding traffic to container on port 3000
  }
}
# IAM Role for ECS Task Execution
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecs_task_execution_role"
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
# Attach Policy to the IAM Roles
resource "aws_iam_role_policy_attachment" "ecs_execution_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  role       = aws_iam_role.ecs_task_execution_role.name
}