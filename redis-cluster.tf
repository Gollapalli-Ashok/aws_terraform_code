/*
## Elastic Cache Redis Cluster Creation
resource "aws_elasticache_parameter_group" "hnk_dev_esredis_dev" {
    name = "cache-params"
    family = "redis6.x"
}

resource "aws_elasticache_subnet_group" "hnk_redis_subnet" {
    name = "hnk-dev-cache-subnet"
    subnet_ids = [aws_subnet.private_subnet_05.id, aws_subnet.private_subnet_06.id]
tags = {
  "name" = "REDIS-SUBNET-GROUP-HNK-PHASE3"
  }
}

resource "aws_elasticache_replication_group" "redis_elasticrep_hnk" {
  replication_group_id          = "hnk-redis-cluster-phase3"
  replication_group_description = "hnk redis cluster replica group"
  node_type                     = var.node_type
  at_rest_encryption_enabled    = true
  transit_encryption_enabled    = true
  number_cache_clusters         = var.num_cache_nodes
  port                          = var.redis_port
  engine                       = "redis"
  engine_version                = var.engine_version
  parameter_group_name          = var.parameter_group_name_hnk
  automatic_failover_enabled    = var.automatic_failover_enabled
  subnet_group_name = aws_elasticache_subnet_group.hnk_redis_subnet.name
  security_group_ids = [aws_security_group.vpc_sg.id]
  maintenance_window = var.window
  tags = {
    "name" = "HNK-RDS-REPLICAGROUP-PHASE3"
  }
}

*/