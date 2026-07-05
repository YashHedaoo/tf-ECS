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



variable "enable_auto_observability" {
  type        = bool
  description = "Whether to enable the Lambda-based region-wide auto-observability scanner"
  default     = false
}

variable "tags" {
  type        = map(string)
  description = "A mapping of tags to assign to all resources created"
  default = {
    ManagedBy = "Terraform"
    Project   = "Dynatrace-ECS-OneAgent-Daemon"
  }
}

variable "oneagent_installer_script_url" {
  type        = string
  description = "The Dynatrace OneAgent installer script URL (e.g., https://<env-id>.live.dynatrace.com/api/v1/deployment/installer/...)"
  sensitive   = true
  default     = ""
}

variable "project_tag_value" {
  type        = string
  description = "The value of the Project tag to assign to the new resources (e.g. electricity.com)"
  default     = ""
}
