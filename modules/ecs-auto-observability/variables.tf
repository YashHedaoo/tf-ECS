variable "oneagent_task_definition_arn" {
  type        = string
  description = "The ARN of the OneAgent task definition to deploy"
}

variable "ecs_task_execution_role_arn" {
  type        = string
  description = "The ARN of the ECS task execution role"
}

variable "ecs_task_role_arn" {
  type        = string
  description = "The ARN of the ECS task role"
}

variable "environment" {
  type        = string
  description = "The environment name"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to all resources"
  default     = {}
}

variable "monitored_clusters" {
  type        = string
  description = "Comma-separated list of ECS cluster names where Dynatrace OneAgent should be deployed."
}

variable "project_tag_key" {
  type        = string
  description = "The tag key to identify which ECS clusters belong to a project (default: Project)"
  default     = "Project"
}

variable "project_tag_value" {
  type        = string
  description = "The tag value corresponding to the project (e.g., electricity.com)"
  default     = ""
}


