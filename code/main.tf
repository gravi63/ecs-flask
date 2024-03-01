provider "aws" {
  region = var.region
  /* shared_credentials_files = ["/root/.aws/credentials"]
    profile                  = "default"
    assume_role {
        role_arn = "arn:aws:iam::${local.tfvars_data.aws_account_id}:role/svc-network-adm-role"
    } */
}

module "vpc" {
  source   = "../modules/vpc"
  region   = var.region
  vpc_cidr = var.vpc_cidr
}

module "ecs" {
  source = "../modules/ecs"
}

resource "null_resource" "docker_packaging" {
  provisioner "local-exec" {
    command = <<EOF
	    aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin public.ecr.aws/${var.ecr_account_id}
	    docker build -t ${var.ec2_repo_name} ../flask-hello-world
	    docker tag ${var.ec2_repo_name}:latest public.ecr.aws/${var.ecr_account_id}/${var.ec2_repo_name}:latest
	    docker push public.ecr.aws/v7y7h1u7/ravig:latest
	    EOF
  }
  triggers = {
    "run_at" = timestamp()
  }
}

resource "aws_ecs_task_definition" "ecs_task_definition" {
  family                   = "my-ecs-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = "arn:aws:iam::650453409529:role/ecsTaskExecutionRole"
  cpu                      = 512
  memory                   = 1024
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
  container_definitions = jsonencode([
    {
      name      = "dockergs"
      image     = "public.ecr.aws/v7y7h1u7/ravig:latest"
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 5000
          hostPort      = 5000
          protocol      = "tcp"
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "ecs_service" {
  name            = "my-ecs-service"
  cluster         = module.ecs.ecs_cluster_id
  task_definition = aws_ecs_task_definition.ecs_task_definition.arn
  launch_type     = "FARGATE"
  network_configuration {
    subnets          = [module.vpc.subnet1_id, module.vpc.subnet2_id]
    security_groups  = [module.vpc.security_groups]
    assign_public_ip = true
  }
  desired_count = 1
}
