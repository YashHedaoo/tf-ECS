locals {
  project_tags = var.project_tag_value != "" ? merge(var.tags, { Project = var.project_tag_value }) : var.tags
}

data "aws_ecs_cluster" "existing" {
  cluster_name = var.cluster_name
}

module "iam" {
  source      = "./modules/iam"
  environment = var.environment
  tags        = local.project_tags
}

module "secrets" {
  source               = "./modules/secrets"
  dynatrace_paas_token = var.dynatrace_paas_token
  dynatrace_url        = var.dynatrace_url
  environment          = var.environment
  tags                 = local.project_tags
}

module "oneagent" {
  source                        = "./modules/oneagent"
  ecs_cluster_id                = data.aws_ecs_cluster.existing.arn
  ecs_cluster_name              = data.aws_ecs_cluster.existing.cluster_name
  ecs_task_execution_role_arn   = module.iam.ecs_task_execution_role_arn
  ecs_task_role_arn             = module.iam.ecs_task_role_arn
  api_url_secret_arn            = module.secrets.api_url_secret_arn
  paas_token_secret_arn         = module.secrets.paas_token_secret_arn
  aws_region                    = var.aws_region
  environment                   = var.environment
  tags                          = local.project_tags
  oneagent_installer_script_url = var.oneagent_installer_script_url
  create_service                = true
}

module "auto_observability" {
  count                        = var.enable_auto_observability ? 1 : 0
  source                       = "./modules/ecs-auto-observability"
  oneagent_task_definition_arn = module.oneagent.task_definition_arn
  ecs_task_execution_role_arn  = module.iam.ecs_task_execution_role_arn
  ecs_task_role_arn            = module.iam.ecs_task_role_arn
  environment                  = var.environment
  tags                         = local.project_tags
  monitored_clusters           = var.monitored_clusters
}
