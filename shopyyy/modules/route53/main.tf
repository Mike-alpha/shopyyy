resource "aws_route53_zone" "main" {
  name = var.domain_name

  tags = merge(var.common_tags, {
    Name = var.domain_name
  })
}

# Alias record for apex domain pointing to CloudFront
resource "aws_route53_record" "apex" {
  count   = var.cloudfront_domain_name != "" ? 1 : 0
  zone_id = aws_route53_zone.main.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = var.cloudfront_domain_name
    zone_id                = var.cloudfront_hosted_zone_id
    evaluate_target_health = false
  }
}

# Alias record for www subdomain pointing to CloudFront
resource "aws_route53_record" "www" {
  count   = var.cloudfront_domain_name != "" ? 1 : 0
  zone_id = aws_route53_zone.main.zone_id
  name    = "www.${var.domain_name}"
  type    = "A"

  alias {
    name                   = var.cloudfront_domain_name
    zone_id                = var.cloudfront_hosted_zone_id
    evaluate_target_health = false
  }
}

output "zone_id" {
  value = aws_route53_zone.main.zone_id
}

output "name_servers" {
  value = aws_route53_zone.main.name_servers
}

output "domain_name" {
  value = aws_route53_zone.main.name
}
