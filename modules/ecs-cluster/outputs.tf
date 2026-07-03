output "cluster_id" {
  value = var.create_cluster ? aws_ecs_cluster.main[0].id : var.existing_cluster_id
}

output "cluster_name" {
  value = var.create_cluster ? aws_ecs_cluster.main[0].name : var.cluster_name
}
