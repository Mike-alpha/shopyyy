resource "aws_vpc" "vpc" {
  for_each             = var.vpcs
  cidr_block           = each.value.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(var.common_tags, {
    Name = each.value.name
  })
}

output "vpc_ids" {
  value = merge(
    { for k, v in aws_vpc.vpc : k => v.id },
    { for k, v in aws_vpc.vpc : lookup(v.tags, "Name", k) => v.id }
  )
}
