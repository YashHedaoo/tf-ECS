resource "aws_ecs_cluster" "main" {
  count = var.create_cluster ? 1 : 0
  name  = "${var.cluster_name}-${var.environment}"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = var.tags
}
