resource "aws_eip" "nat" {
  for_each = var.nat_gateways
  domain   = "vpc"

  tags = merge(var.common_tags, {
    Name = "${each.value.name}-eip"
  })
}

resource "aws_nat_gateway" "nat" {
  for_each      = var.nat_gateways
  allocation_id = aws_eip.nat[each.key].id
  subnet_id     = lookup(var.subnet_ids, lookup(each.value, "subnet_name", lookup(each.value, "subnet_key", "")), null)

  tags = merge(var.common_tags, {
    Name = each.value.name
  })
}

output "nat_gateway_ids" {
  value = merge(
    { for k, v in aws_nat_gateway.nat : k => v.id },
    { for k, v in aws_nat_gateway.nat : lookup(v.tags, "Name", k) => v.id }
  )
}
