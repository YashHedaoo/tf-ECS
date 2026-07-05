variable "dynatrace_url" {
  type        = string
  description = "The Dynatrace Environment URL (e.g., https://xyz123.live.dynatrace.com)"
}

variable "dynatrace_paas_token" {
  type        = string
  description = "The Dynatrace PaaS/Installer Token with download permission for the OneAgent script"
  sensitive   = true
}

variable "aws_account_id" {
  type        = string
  description = "The AWS Account ID of the target account being monitored"
  default     = ""
}

variable "aws_region" {
  type        = string
  description = "The AWS region to deploy monitoring infrastructure and configurations"
  default     = "us-east-1"
}

variable "environment" {
  type        = string
  description = "The deployment environment (e.g. dev, test, stage)"
  default     = "production"
}

variable "cluster_name" {
  type        = string
  description = "The name of the ECS cluster to create"
  default     = "ecs-oneagent-cluster"
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

variable "instance_type" {
  type        = string
  description = "The EC2 instance type for the ECS hosts"
  default     = "t3.medium"
}

variable "ami_id" {
  type        = string
  description = "The ECS optimized AMI ID. If empty, the latest is fetched dynamically."
  default     = ""
}

variable "availability_zones" {
  type        = list(string)
  description = "The availability zones to deploy into"
  default     = ["us-east-1a", "us-east-1b"]
}

variable "tags" {
  type        = map(string)
  description = "A mapping of tags to assign to all resources created"
  default = {
    ManagedBy = "Terraform"
    Project   = "Dynatrace-ECS-OneAgent-Daemon"
  }
}

variable "monitored_clusters" {
  type        = string
  description = "Comma-separated list of ECS cluster names where Dynatrace OneAgent should be deployed. Use '*' to monitor all clusters."
  default     = "*"
}

variable "oneagent_installer_script_url" {
  type        = string
  description = "The Dynatrace OneAgent installer script URL (e.g., https://<env-id>.live.dynatrace.com/api/v1/deployment/installer/...)"
  sensitive   = true
  default     = ""
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


