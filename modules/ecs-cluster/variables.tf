variable "cluster_name" {
  type        = string
  description = "The name of the ECS cluster"
}

variable "create_cluster" {
  type        = bool
  description = "Whether to create a new cluster or reference an existing one"
  default     = true
}

variable "existing_cluster_id" {
  type        = string
  description = "The ID of the existing ECS cluster (required if create_cluster = false)"
  default     = ""
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
