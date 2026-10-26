resource "random_password" "db_password" {
  length  = 16
  special = false
}

resource "aws_secretsmanager_secret" "db_secret" {
  name                    = "${var.identifier}-credentials"
  recovery_window_in_days = 0

  tags = merge(var.common_tags, {
    Name = "${var.identifier}-credentials"
  })
}

resource "aws_secretsmanager_secret_version" "db_secret_version" {
  secret_id = aws_secretsmanager_secret.db_secret.id
  secret_string = jsonencode({
    engine   = "postgres"
    host     = aws_db_instance.postgres.address
    port     = aws_db_instance.postgres.port
    username = var.username
    password = random_password.db_password.result
    database = var.db_name
  })
}

resource "aws_db_subnet_group" "rds" {
  name        = "${var.identifier}-subnet-group"
  description = "Subnet group for RDS PostgreSQL"
  subnet_ids  = var.private_subnet_ids

  tags = merge(var.common_tags, {
    Name = "${var.identifier}-subnet-group"
  })
}

resource "aws_db_instance" "postgres" {
  identifier             = var.identifier
  engine                 = "postgres"
  engine_version         = "17.2"
  instance_class         = var.instance_class
  allocated_storage      = var.allocated_storage
  storage_type           = "gp3"
  db_name                = var.db_name
  username               = var.username
  password               = random_password.db_password.result
  multi_az               = true
  publicly_accessible    = false
  db_subnet_group_name   = aws_db_subnet_group.rds.name
  vpc_security_group_ids = var.security_group_ids
  skip_final_snapshot    = true

  tags = merge(var.common_tags, {
    Name = var.identifier
  })
}

output "endpoint" {
  value = aws_db_instance.postgres.endpoint
}

output "address" {
  value = aws_db_instance.postgres.address
}

output "port" {
  value = aws_db_instance.postgres.port
}

output "secret_arn" {
  value = aws_secretsmanager_secret.db_secret.arn
}

output "db_name" {
  value = var.db_name
}
