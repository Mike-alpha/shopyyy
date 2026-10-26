resource "aws_subnet" "subnet" {
  for_each                = var.subnets
  vpc_id                  = lookup(var.vpc_ids, lookup(each.value, "vpc_name", lookup(each.value, "vpc_key", "")), null)
  cidr_block              = each.value.cidr_block
  availability_zone       = lookup(each.value, "availability_zone", null)
  map_public_ip_on_launch = lookup(each.value, "is_public", false)

  tags = merge(var.common_tags, {
    Name = each.value.name
    Type = lookup(each.value, "is_public", false) ? "Public" : "Private"
  })
}

output "subnet_ids" {
  value = merge(
    { for k, v in aws_subnet.subnet : k => v.id },
    { for k, v in aws_subnet.subnet : lookup(v.tags, "Name", k) => v.id }
  )
}
