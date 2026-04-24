resource "aws_db_subnet_group" "this" {
  name       = "${var.identifier}-subnet-group"
  subnet_ids = var.subnet_ids

  tags = merge(var.tags, { Name = "${var.identifier}-subnet-group" })
}

resource "aws_security_group" "this" {
  name        = "${var.identifier}-sg"
  description = "Security group for ${var.identifier} database"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = local.db_port
    to_port     = local.db_port
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, { Name = "${var.identifier}-sg" })
}

resource "aws_db_parameter_group" "this" {
  name   = "${var.identifier}-param-group"
  family = local.parameter_group_family

  parameter {
    name  = "max_connections"
    value = "200"
  }

  dynamic "parameter" {
    for_each = local.is_postgres ? [1] : []
    content {
      name  = "log_statement"
      value = "all"
    }
  }

  dynamic "parameter" {
    for_each = local.is_postgres ? [1] : []
    content {
      name  = "work_mem"
      value = "16384"
    }
  }

  tags = merge(var.tags, { Name = "${var.identifier}-param-group" })
}

locals {
  is_postgres = can(regex("postgres", var.engine))
  is_aurora   = var.use_aurora

  db_port = local.is_postgres ? 5432 : 3306

  parameter_group_family = local.is_aurora ? (
    local.is_postgres ? "aurora-postgresql15" : "aurora-mysql8.0"
  ) : (
    local.is_postgres ? "postgres15" : "mysql8.0"
  )
}
