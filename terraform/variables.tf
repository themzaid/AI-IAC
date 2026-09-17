# ---------------------------------------------------------------
# Hello API – Input Variables
# ---------------------------------------------------------------

variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "us-east-1"
}

variable "app_name" {
  description = "Application name used for resource naming"
  type        = string
  default     = "hello-api"
}

variable "container_port" {
  description = "Port the container listens on"
  type        = number
  default     = 8989
}

variable "task_cpu" {
  description = "Fargate task CPU units (1 vCPU = 1024)"
  type        = number
  default     = 256
}

variable "task_memory" {
  description = "Fargate task memory in MiB"
  type        = number
  default     = 512
}

variable "desired_count" {
  description = "Number of ECS tasks to run"
  type        = number
  default     = 1
}
