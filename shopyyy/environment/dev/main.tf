locals {
  name_prefix = "${var.project}-${var.environment}"
  common_tags = merge(var.common_tags, {
    Project     = var.project
    Environment = var.environment
  })

  all_subnets = merge(var.public_subnets, var.private_subnets)

  public_subnet_names  = keys(var.public_subnets)
  private_subnet_names = keys(var.private_subnets)
}

# 1. Networking - VPC
module "vpc" {
  source = "../../modules/vpc"
  vpcs = {
    "${local.name_prefix}-vpc" = {
      name       = "${local.name_prefix}-vpc"
      cidr_block = var.vpc_cidr
    }
  }
  common_tags = local.common_tags
}

# 2. Networking - Subnets (2 public and 2 private across AZs)
module "subnet" {
  source      = "../../modules/subnet"
  subnets     = local.all_subnets
  vpc_ids     = module.vpc.vpc_ids
  common_tags = local.common_tags
  depends_on  = [module.vpc]
}

# 3. Networking - Internet Gateway for public subnets
module "internet_gateway" {
  source = "../../modules/internet-gateway"
  internet_gateways = {
    "${local.name_prefix}-igw" = {
      name     = "${local.name_prefix}-igw"
      vpc_name = "${local.name_prefix}-vpc"
    }
  }
  vpc_ids     = module.vpc.vpc_ids
  common_tags = local.common_tags
  depends_on  = [module.vpc]
}

# 4. Networking - NAT Gateway for private subnets internet access
module "nat_gateway" {
  source = "../../modules/nat-gateway"
  nat_gateways = {
    "${local.name_prefix}-nat" = {
      name        = "${local.name_prefix}-nat"
      subnet_name = local.public_subnet_names[0]
    }
  }
  subnet_ids  = module.subnet.subnet_ids
  common_tags = local.common_tags
  depends_on  = [module.subnet]
}

# 5. Networking - Route Tables
module "route_table" {
  source = "../../modules/route-table"
  route_tables = {
    public_rt = {
      name     = "${local.name_prefix}-public-rt"
      vpc_name = "${local.name_prefix}-vpc"
    }
    private_rt = {
      name     = "${local.name_prefix}-private-rt"
      vpc_name = "${local.name_prefix}-vpc"
    }
  }
  routes = {
    public_igw_route = {
      route_table_key        = "public_rt"
      destination_cidr_block = "0.0.0.0/0"
      gateway_name           = "${local.name_prefix}-igw"
    }
    private_nat_route = {
      route_table_key        = "private_rt"
      destination_cidr_block = "0.0.0.0/0"
      nat_gateway_name       = "${local.name_prefix}-nat"
    }
  }
  route_table_associations = merge(
    {
      for idx, name in local.public_subnet_names : "public_assoc_${idx}" => {
        subnet_name     = name
        route_table_key = "public_rt"
      }
    },
    {
      for idx, name in local.private_subnet_names : "private_assoc_${idx}" => {
        subnet_name     = name
        route_table_key = "private_rt"
      }
    }
  )
  vpc_ids         = module.vpc.vpc_ids
  igw_ids         = module.internet_gateway.igw_ids
  nat_gateway_ids = module.nat_gateway.nat_gateway_ids
  subnet_ids      = module.subnet.subnet_ids
  common_tags     = local.common_tags
  depends_on      = [module.subnet, module.internet_gateway, module.nat_gateway]
}

# 6. Security Groups
module "security_groups" {
  source      = "../../modules/security-groups"
  vpc_id      = module.vpc.vpc_ids["${local.name_prefix}-vpc"]
  project     = var.project
  environment = var.environment
  common_tags = local.common_tags
  depends_on  = [module.vpc]
}

# 7. DNS - Route 53
module "route53" {
  source      = "../../modules/route53"
  domain_name = var.domain_name
  common_tags = local.common_tags
}

# 8. SSL - ACM Certificate
module "acm" {
  source                    = "../../modules/acm"
  domain_name               = var.domain_name
  subject_alternative_names = ["*.${var.domain_name}"]
  zone_id                   = module.route53.zone_id
  common_tags               = local.common_tags
  depends_on                = [module.route53]
}

# 9. Load Balancer (ALB)
module "alb" {
  source             = "../../modules/alb"
  name               = local.name_prefix
  vpc_id             = module.vpc.vpc_ids["${local.name_prefix}-vpc"]
  public_subnet_ids  = [for name in local.public_subnet_names : module.subnet.subnet_ids[name]]
  security_group_ids = [module.security_groups.alb_sg_id]
  certificate_arn    = module.acm.certificate_arn
  common_tags        = local.common_tags
  depends_on         = [module.subnet, module.security_groups, module.acm]
}

# 10. S3 - Frontend Bucket with OAC
module "s3" {
  source      = "../../modules/s3"
  bucket_name = var.s3_frontend_bucket_name
  common_tags = local.common_tags
}

# 11. CloudFront - Distribution
module "cloudfront" {
  source                = "../../modules/cloudfront"
  name                  = local.name_prefix
  s3_bucket_domain_name = module.s3.bucket_regional_domain_name
  alb_dns_name          = module.alb.dns_name
  acm_certificate_arn   = module.acm.certificate_arn
  aliases               = [var.domain_name, "www.${var.domain_name}"]
  common_tags           = local.common_tags
  depends_on            = [module.s3, module.alb, module.acm]
}

# 12. Database - RDS PostgreSQL 17 Multi-AZ
module "rds" {
  source             = "../../modules/rds"
  identifier         = "${local.name_prefix}-postgres"
  db_name            = var.db_name
  username           = var.db_username
  instance_class     = var.db_instance_class
  allocated_storage  = var.db_allocated_storage
  private_subnet_ids = [for name in local.private_subnet_names : module.subnet.subnet_ids[name]]
  security_group_ids = [module.security_groups.rds_sg_id]
  common_tags        = local.common_tags
  depends_on         = [module.subnet, module.security_groups]
}

# 13. Caching - ElastiCache Redis
module "elasticache" {
  source             = "../../modules/elasticache"
  cluster_id         = "${local.name_prefix}-redis"
  node_type          = var.redis_node_type
  private_subnet_ids = [for name in local.private_subnet_names : module.subnet.subnet_ids[name]]
  security_group_ids = [module.security_groups.elasticache_sg_id]
  common_tags        = local.common_tags
  depends_on         = [module.subnet, module.security_groups]
}

# 14. Kafka - Amazon MSK
module "msk" {
  source               = "../../modules/msk"
  cluster_name         = "${local.name_prefix}-msk"
  kafka_version        = var.msk_kafka_version
  broker_instance_type = var.msk_broker_instance_type
  private_subnet_ids   = [for name in local.private_subnet_names : module.subnet.subnet_ids[name]]
  security_group_ids   = [module.security_groups.msk_sg_id]
  common_tags          = local.common_tags
  depends_on           = [module.subnet, module.security_groups]
}

# 15. Compute - ECS Fargate Service
module "ecs" {
  source             = "../../modules/ecs"
  cluster_name       = "${local.name_prefix}-cluster"
  service_name       = "${local.name_prefix}-service"
  container_image    = var.container_image
  container_port     = var.container_port
  cpu                = var.ecs_cpu
  memory             = var.ecs_memory
  desired_count      = var.ecs_desired_count
  private_subnet_ids = [for name in local.private_subnet_names : module.subnet.subnet_ids[name]]
  security_group_ids = [module.security_groups.ecs_sg_id]
  target_group_arn   = module.alb.target_group_arn
  db_secret_arn      = module.rds.secret_arn
  db_url             = "postgresql://${var.db_username}@${module.rds.endpoint}/${var.db_name}"
  redis_url          = "redis://${module.elasticache.endpoint}:${module.elasticache.port}"
  common_tags        = local.common_tags
  depends_on         = [module.subnet, module.security_groups, module.alb, module.rds, module.elasticache]
}
