output "vpc_id" {
  description = "The ID of the created VPC"
  value       = module.ecs_oneagent_integration.vpc_id
}

output "ecs_cluster_name" {
  description = "The name of the ECS cluster"
  value       = module.ecs_oneagent_integration.ecs_cluster_name
}

output "auto_observability_lambda_arn" {
  description = "The ARN of the Lambda Auto-Observability Controller"
  value       = module.ecs_oneagent_integration.auto_observability_lambda_arn
}
