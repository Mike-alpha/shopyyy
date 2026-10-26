resource "aws_msk_cluster" "msk" {
  cluster_name           = var.cluster_name
  kafka_version          = var.kafka_version
  number_of_broker_nodes = 2

  broker_node_group_info {
    instance_type   = var.broker_instance_type
    client_subnets  = slice(var.private_subnet_ids, 0, 2)
    security_groups = var.security_group_ids

    storage_info {
      ebs_storage_info {
        volume_size = 20
      }
    }
  }

  encryption_info {
    encryption_in_transit {
      client_broker = "PLAINTEXT"
      in_cluster    = true
    }
  }

  tags = merge(var.common_tags, {
    Name = var.cluster_name
  })
}

output "bootstrap_brokers" {
  value = aws_msk_cluster.msk.bootstrap_brokers
}

output "bootstrap_brokers_tls" {
  value = aws_msk_cluster.msk.bootstrap_brokers_tls
}

output "arn" {
  value = aws_msk_cluster.msk.arn
}
