# lesson-db-module — Universal RDS Terraform Module

Universal `rds` module that creates either a standard RDS instance or an Aurora cluster based on the `use_aurora` variable.

## Module Features

- `use_aurora = false` → creates `aws_db_instance` (standard RDS)
- `use_aurora = true` → creates `aws_rds_cluster` + writer `aws_rds_cluster_instance`
- Always creates:
  - `aws_db_subnet_group`
  - `aws_security_group` with configurable CIDR ingress
  - `aws_db_parameter_group` with `max_connections`, `log_statement`, `work_mem`

## Usage Example

### Standard RDS PostgreSQL

```hcl
module "rds" {
  source            = "./modules/rds"
  identifier        = "my-postgres"
  use_aurora        = false
  engine            = "postgres"
  engine_version    = "15.4"
  instance_class    = "db.t3.medium"
  allocated_storage = 20
  db_name           = "myappdb"
  db_username       = "myappuser"
  db_password       = "myapppass"
  multi_az          = false
  vpc_id            = module.vpc.vpc_id
  subnet_ids        = module.vpc.private_subnet_ids
}
```

### Aurora PostgreSQL Cluster

```hcl
module "rds_aurora" {
  source         = "./modules/rds"
  identifier     = "my-aurora"
  use_aurora     = true
  engine         = "aurora-postgresql"
  engine_version = "15.4"
  instance_class = "db.r6g.large"
  db_name        = "myappdb"
  db_username    = "myappuser"
  db_password    = "myapppass"
  vpc_id         = module.vpc.vpc_id
  subnet_ids     = module.vpc.private_subnet_ids
}
```

## Variables

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `identifier` | string | — | Unique name for the DB / cluster |
| `use_aurora` | bool | `false` | `true` = Aurora cluster, `false` = standard RDS |
| `engine` | string | `postgres` | DB engine: `postgres`, `mysql`, `aurora-postgresql`, `aurora-mysql` |
| `engine_version` | string | `15.4` | Engine version |
| `instance_class` | string | `db.t3.medium` | Instance type |
| `allocated_storage` | number | `20` | Storage in GB (RDS only) |
| `db_name` | string | `mydb` | Initial database name |
| `db_username` | string | `admin` | Master username |
| `db_password` | string | — | Master password (sensitive) |
| `multi_az` | bool | `false` | Multi-AZ deployment (RDS only) |
| `vpc_id` | string | — | VPC ID |
| `subnet_ids` | list(string) | — | Private subnet IDs |
| `allowed_cidr_blocks` | list(string) | `["10.0.0.0/16"]` | CIDRs allowed to connect |
| `tags` | map(string) | `{}` | Tags for all resources |

## How to Change DB Type / Engine / Instance Class

| Goal | Change |
|------|--------|
| Switch to Aurora | `use_aurora = true`, `engine = "aurora-postgresql"` |
| Switch to MySQL | `engine = "mysql"`, `engine_version = "8.0"` |
| Larger instance | `instance_class = "db.r6g.large"` |
| Enable Multi-AZ | `multi_az = true` (RDS only) |
| More storage | `allocated_storage = 100` (RDS only) |

## Terraform Commands

```bash
terraform init
terraform plan
terraform apply
terraform destroy
```

> WARNING: `terraform destroy` also deletes S3/DynamoDB used for state storage.
