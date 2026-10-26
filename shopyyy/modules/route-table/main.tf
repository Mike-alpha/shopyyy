resource "aws_route_table" "route_table" {
  for_each = var.route_tables
  vpc_id   = lookup(var.vpc_ids, lookup(each.value, "vpc_name", lookup(each.value, "vpc_key", "")), null)

  tags = merge(var.common_tags, {
    Name = each.value.name
  })
}

resource "aws_route" "route" {
  for_each               = var.routes
  route_table_id         = aws_route_table.route_table[each.value.route_table_key].id
  destination_cidr_block = each.value.destination_cidr_block
  gateway_id             = lookup(each.value, "gateway_name", null) != null ? lookup(var.igw_ids, each.value.gateway_name, null) : null
  nat_gateway_id         = lookup(each.value, "nat_gateway_name", null) != null ? lookup(var.nat_gateway_ids, each.value.nat_gateway_name, null) : null
}

resource "aws_route_table_association" "association" {
  for_each       = var.route_table_associations
  subnet_id      = lookup(var.subnet_ids, lookup(each.value, "subnet_name", lookup(each.value, "subnet_key", "")), null)
  route_table_id = aws_route_table.route_table[each.value.route_table_key].id
}

output "route_table_ids" {
  value = merge(
    { for k, v in aws_route_table.route_table : k => v.id },
    { for k, v in aws_route_table.route_table : lookup(v.tags, "Name", k) => v.id }
  )
}
