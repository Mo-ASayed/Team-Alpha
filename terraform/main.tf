# Root main.tf

module "vpc" {
  source               = "./modules/vpc"
  vpc_cidr             = var.vpc_cidr
  vpc_name             = "tm-vpc"
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
  sg_name              = var.sg_name
}

module "alb" {
  source            = "./modules/alb"
  alb-name          = var.alb-name
  security_group_id = module.vpc.sg_id
  subnet_ids        = module.vpc.public_subnets
  target-group-name = var.target-group-name
  target_port       = var.container_port
  vpc_id            = module.vpc.vpc_id
  certificate_arn   = var.certificate_arn
}

module "ecs" {
  source             = "./modules/ecs"
  cluster_name       = "tm-cluster"
  task_family        = "tm-task"
  task_cpu           = "1024"
  task_memory        = "2048"
  container_name     = "threatmodel"
  container_image    = var.container_image
  container_port     = var.container_port
  service_name       = "tm-service"
  desired_count      = var.desired_count
  subnet_ids         = module.vpc.public_subnets
  security_group_ids = [module.vpc.sg_id]
  target_group_arn   = module.alb.target_group_arn
  listener_http_arn  = module.alb.listener_http_arn
  listener_https_arn = module.alb.listener_https_arn


  # IAM roles are conditionally created in the ECS module
  create_iam_role    = var.create_iam_role
  execution_role_arn = var.create_iam_role ? null : "arn:aws:iam::992382674979:role/ecsTaskExecutionRole"
  task_role_arn      = var.create_iam_role ? null : "arn:aws:iam::992382674979:role/ecsTaskExecutionRole"
  iam_role_name      = "ecs_task_execution_role"
}

module "route53" {
  source       = "./modules/route53"
  zone_name    = var.zone_name
  record_name  = var.record_name
  alb_dns_name = module.alb.alb_dns_name
  lb_dns_name  = module.alb.dns_name
  lb_zone_id   = module.alb.zone_id
}
