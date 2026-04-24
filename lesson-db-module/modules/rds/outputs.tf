output "endpoint" {
  description = "Database endpoint (writer endpoint for Aurora, instance endpoint for RDS)"
  value       = var.use_aurora ? aws_rds_cluster.this[0].endpoint : aws_db_instance.this[0].address
}

output "port" {
  description = "Database port"
  value       = local.db_port
}

output "db_name" {
  description = "Database name"
  value       = var.db_name
}

output "security_group_id" {
  description = "Security group ID"
  value       = aws_security_group.this.id
}

output "subnet_group_name" {
  description = "DB subnet group name"
  value       = aws_db_subnet_group.this.name
}
