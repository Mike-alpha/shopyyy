output "cloudfront_domain_name" {
  value = module.cloudfront.domain_name
}

output "alb_dns_name" {
  value = module.alb.dns_name
}

output "rds_endpoint" {
  value = module.rds.endpoint
}

output "redis_endpoint" {
  value = module.elasticache.endpoint
}

output "msk_bootstrap_brokers" {
  value = module.msk.bootstrap_brokers
}

output "route53_name_servers" {
  value = module.route53.name_servers
}
