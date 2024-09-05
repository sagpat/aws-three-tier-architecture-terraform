# Aurora RDS Cluster
resource "aws_rds_cluster" "aurora" {
  cluster_identifier     = "aurora-cluster"
  engine                 = "aurora-mysql"
  engine_version         = "8.0.mysql_aurora.3.06.0"
  database_name          = "ThreeTierDb"
  master_username        = var.db_user
  master_password        = var.db_pwd
  vpc_security_group_ids = [var.db_security_group]
  db_subnet_group_name   = aws_db_subnet_group.this.name
  skip_final_snapshot    = true
}

# Aurora RDS Cluster Instances
resource "aws_rds_cluster_instance" "aurora_instances" {
  count              = 2
  identifier         = "aurora-instance-${count.index + 1}"
  cluster_identifier = aws_rds_cluster.aurora.id
  instance_class     = "db.t3.medium"
  #db.t4g.small to use as it costs $0.0320/hr against db.r5.large which is $0.2500/hr
  engine               = aws_rds_cluster.aurora.engine
  engine_version       = aws_rds_cluster.aurora.engine_version
  publicly_accessible  = false
  db_subnet_group_name = aws_db_subnet_group.this.name

  tags = merge(module.tags.tags, { Name = "Aurora Instance ${count.index + 1}" })
}