# 1. ALB Security Group
resource "aws_security_group" "alb" {
  name        = "${var.project}-${var.environment}-alb-sg"
  description = "Security group for Application Load Balancer"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow HTTPS from CloudFront / Clients"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, {
    Name = "${var.project}-${var.environment}-alb-sg"
  })
}

# 2. ECS Security Group
resource "aws_security_group" "ecs" {
  name        = "${var.project}-${var.environment}-ecs-sg"
  description = "Security group for ECS tasks"
  vpc_id      = var.vpc_id

  tags = merge(var.common_tags, {
    Name = "${var.project}-${var.environment}-ecs-sg"
  })
}

# Ingress: ALB -> ECS on port 3000
resource "aws_security_group_rule" "ecs_ingress_alb" {
  type                     = "ingress"
  from_port                = 3000
  to_port                  = 3000
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.alb.id
  security_group_id        = aws_security_group.ecs.id
  description              = "Allow inbound traffic from ALB on port 3000"
}

# Egress: ALB -> ECS on port 3000
resource "aws_security_group_rule" "alb_egress_ecs" {
  type                     = "egress"
  from_port                = 3000
  to_port                  = 3000
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.ecs.id
  security_group_id        = aws_security_group.alb.id
  description              = "Allow outbound traffic from ALB to ECS on port 3000"
}

# 3. RDS Security Group
resource "aws_security_group" "rds" {
  name        = "${var.project}-${var.environment}-rds-sg"
  description = "Security group for RDS PostgreSQL"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Allow PostgreSQL from ECS SG only"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.ecs.id]
  }

  tags = merge(var.common_tags, {
    Name = "${var.project}-${var.environment}-rds-sg"
  })
}

# 4. ElastiCache Redis Security Group
resource "aws_security_group" "elasticache" {
  name        = "${var.project}-${var.environment}-redis-sg"
  description = "Security group for ElastiCache Redis"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Allow Redis from ECS SG only"
    from_port       = 6379
    to_port         = 6379
    protocol        = "tcp"
    security_groups = [aws_security_group.ecs.id]
  }

  tags = merge(var.common_tags, {
    Name = "${var.project}-${var.environment}-redis-sg"
  })
}

# 5. MSK Security Group
resource "aws_security_group" "msk" {
  name        = "${var.project}-${var.environment}-msk-sg"
  description = "Security group for Amazon MSK"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Allow Kafka plaintext from ECS SG only"
    from_port       = 9092
    to_port         = 9092
    protocol        = "tcp"
    security_groups = [aws_security_group.ecs.id]
  }

  ingress {
    description     = "Allow Kafka TLS from ECS SG only"
    from_port       = 9094
    to_port         = 9094
    protocol        = "tcp"
    security_groups = [aws_security_group.ecs.id]
  }

  tags = merge(var.common_tags, {
    Name = "${var.project}-${var.environment}-msk-sg"
  })
}

# ECS Outbound Rules to RDS, ElastiCache, MSK, and HTTPS (for AWS APIs/Secrets Manager)
resource "aws_security_group_rule" "ecs_egress_rds" {
  type                     = "egress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.rds.id
  security_group_id        = aws_security_group.ecs.id
  description              = "Allow ECS outbound to RDS"
}

resource "aws_security_group_rule" "ecs_egress_redis" {
  type                     = "egress"
  from_port                = 6379
  to_port                  = 6379
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.elasticache.id
  security_group_id        = aws_security_group.ecs.id
  description              = "Allow ECS outbound to ElastiCache"
}

resource "aws_security_group_rule" "ecs_egress_msk" {
  type                     = "egress"
  from_port                = 9092
  to_port                  = 9092
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.msk.id
  security_group_id        = aws_security_group.ecs.id
  description              = "Allow ECS outbound to MSK plaintext"
}

resource "aws_security_group_rule" "ecs_egress_https" {
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ecs.id
  description       = "Allow ECS outbound HTTPS for ECR, CloudWatch, and Secrets Manager"
}

output "alb_sg_id" {
  value = aws_security_group.alb.id
}

output "ecs_sg_id" {
  value = aws_security_group.ecs.id
}

output "rds_sg_id" {
  value = aws_security_group.rds.id
}

output "elasticache_sg_id" {
  value = aws_security_group.elasticache.id
}

output "msk_sg_id" {
  value = aws_security_group.msk.id
}
