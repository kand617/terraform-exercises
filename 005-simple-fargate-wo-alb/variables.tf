
variable "aws_region" {
  description = "aws_region",
  default="us-west-2"
}

variable "fargate_cpu" {
  description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
  default     = "256"
}

variable "fargate_memory" {
  description = "Fargate instance memory to provision (in MiB)"
  default     = "512"
}


variable "app_image" {
  description = "Docker image to run in the ECS cluster"
  default     = "562185760820.dkr.ecr.us-west-2.amazonaws.com/calculator-service:latest"
}

variable "app_port" {
  description = "Port exposed by the docker image to redirect traffic to"
  default     = "3001"
}


variable "app_count" {
  description = "Number of docker containers to run"
  default     = "2"
}


# variable "ecs_task_execution_role" {
#   description = "Role arn for the ecsTaskExecutionRole"
#   default     = "YOUR_ECS_TASK_EXECUTION_ROLE_ARN"
# }