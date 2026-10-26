resource "aws_elasticache_subnet_group" "redis" {
  name        = "${var.cluster_id}-subnet-group"
  description = "Subnet group for ElastiCache Redis"
  subnet_ids  = var.private_subnet_ids

  tags = merge(var.common_tags, {
    Name = "${var.cluster_id}-subnet-group"
  })
}

resource "aws_elasticache_cluster" "redis" {
  cluster_id           = var.cluster_id
  engine               = "redis"
  node_type            = var.node_type
  num_cache_nodes      = 1
  parameter_group_name = "default.redis7"
  engine_version       = "7.1"
  port                 = 6379
  subnet_group_name    = aws_elasticache_subnet_group.redis.name
  security_group_ids   = var.security_group_ids

  tags = merge(var.common_tags, {
    Name = var.cluster_id
  })
}

output "endpoint" {
  value = aws_elasticache_cluster.redis.cache_nodes[0].address
}

output "port" {
  value = aws_elasticache_cluster.redis.port
}

output "cluster_id" {
  value = aws_elasticache_cluster.redis.cluster_id
}
