variable "identifier" {
  description = "Unique identifier for the RDS instance or Aurora cluster"
  type        = string
}

variable "use_aurora" {
  description = "If true, creates an Aurora cluster. If false, creates a standard RDS instance."
  type        = bool
  default     = false
}

variable "engine" {
  description = "Database engine (mysql, postgres, aurora-mysql, aurora-postgresql)"
  type        = string
  default     = "postgres"
}

variable "engine_version" {
  description = "Database engine version"
  type        = string
  default     = "15.4"
}

variable "instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.medium"
}

variable "allocated_storage" {
  description = "Allocated storage in GB (only for standard RDS)"
  type        = number
  default     = 20
}

variable "db_name" {
  description = "Name of the initial database"
  type        = string
  default     = "mydb"
}

variable "db_username" {
  description = "Master username"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "Master password"
  type        = string
  sensitive   = true
}

variable "multi_az" {
  description = "Enable Multi-AZ deployment (only for standard RDS)"
  type        = bool
  default     = false
}

variable "vpc_id" {
  description = "VPC ID where RDS will be deployed"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for the DB subnet group"
  type        = list(string)
}

variable "allowed_cidr_blocks" {
  description = "CIDR blocks allowed to connect to the database"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
