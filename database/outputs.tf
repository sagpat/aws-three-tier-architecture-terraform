output "mysql_writer_endpoint" {
  value = { for key, value in aws_rds_cluster_instance.aurora_instances : key => value
    if value.writer == true && value.endpoint != null
  }
}

output "aws_rds_cluster_endpoint" {
  value = aws_rds_cluster.aurora.endpoint
}