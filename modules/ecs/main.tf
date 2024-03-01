resource "aws_ecs_cluster" "ecs_cluster" {
    name = "my-ecs-cluster"
}

# resource "aws_ecs_capacity_provider" "ecs_capacity_provider" {
#     name = "test1"
#     auto_scaling_group_provider {
#         auto_scaling_group_arn = var.asg_arn
#     managed_scaling {
#         maximum_scaling_step_size = 1000
#         minimum_scaling_step_size = 1
#         status                    = "ENABLED"
#         target_capacity           = 3
#         }
#     }
# }



resource "aws_ecs_cluster_capacity_providers" "ecs_cluster_providers" {
    cluster_name = aws_ecs_cluster.ecs_cluster.name
    capacity_providers = ["FARGATE"]
    default_capacity_provider_strategy {
        base              = 1
        weight            = 100
        capacity_provider = "FARGATE"
    }
}
