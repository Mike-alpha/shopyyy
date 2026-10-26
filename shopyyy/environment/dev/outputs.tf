output "cloudfront_domain_name" {
  description = "The domain name of the CloudFront distribution"
  value       = module.cloudfront.domain_name
}

output "alb_dns_name" {
  description = "The DNS name of the Application Load Balancer"
  value       = module.alb.dns_name
}

output "rds_endpoint" {
  description = "The connection endpoint for the RDS PostgreSQL database"
  value       = module.rds.endpoint
}

output "redis_endpoint" {
  description = "The endpoint address for the ElastiCache Redis cluster"
  value       = module.elasticache.endpoint
}

output "msk_bootstrap_brokers" {
  description = "The Apache Kafka connection endpoint (bootstrap brokers) for MSK"
  value       = module.msk.bootstrap_brokers
}

output "route53_name_servers" {
  description = "Name servers for the Route53 hosted zone"
  value       = module.route53.name_servers
}
