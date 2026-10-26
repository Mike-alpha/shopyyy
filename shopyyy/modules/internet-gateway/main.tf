resource "aws_internet_gateway" "igw" {
  for_each = var.internet_gateways
  vpc_id   = lookup(var.vpc_ids, lookup(each.value, "vpc_name", lookup(each.value, "vpc_key", "")), null)

  tags = merge(var.common_tags, {
    Name = each.value.name
  })
}

output "igw_ids" {
  value = merge(
    { for k, v in aws_internet_gateway.igw : k => v.id },
    { for k, v in aws_internet_gateway.igw : lookup(v.tags, "Name", k) => v.id }
  )
}
