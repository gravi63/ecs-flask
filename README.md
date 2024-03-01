# ecs-flask

## AWS

- Create Ec2InstanceIAMRole for Ec2 to access ECS
- Create ecsInstanceRole for ECS to access Other resources
- create AWS ECR repo to store Images

## Terraform steps

- cd ./code
- export AWS credentials
- terraform init
- terraform plan
- terraform apply

## Github Actions Pipeline

- Once the code is pushed to Main branch, Code will be deployed.

## Info

- Add Load balancer and Implement SSL for https url