resource "aws_elasticache_parameter_group" "cache_param" {
  name = "cache-params"
  family  = "redis5.0"
}

resource "aws_elasticache_cluster" "main" {
  cluster_id               = "cache-cluster"
  engine                   = "redis"
  node_type                = "cache.m4.large"
  num_cache_nodes          = 1
  parameter_group_name     = aws_elasticache_parameter_group.cache_param.name
  engine_version           = "5.0.6"
  port                     = 6379
  snapshot_retention_limit = 1
}
