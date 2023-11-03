module "db" {
  source = "terraform-aws-modules/rds/aws"

  identifier = "${var.prefix}"

  engine            = "mysql"
  engine_version    = "5.7"
  instance_class    = var.db_instance_type
  allocated_storage = 5

  db_name  = "${var.prefix}"
  username = "wordpress"
  port     = "3306"

  #AWS RDS will mantain the password and will store it in Secrets Manager
  manage_master_user_password = true

  iam_database_authentication_enabled = true
  multi_az               = true
  vpc_security_group_ids = [module.server_sg_private.security_group_id]

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"
  enabled_cloudwatch_logs_exports = ["general", "audit"]
  create_cloudwatch_log_group     = true
  blue_green_update = {
    enabled = true
  }

  # Enhanced Monitoring - see example for details on how to create the role
  # by yourself, in case you don't want to create it automatically
  #performance_insights_enabled          = true
  #performance_insights_retention_period = 7
  monitoring_interval    = "30"
  monitoring_role_name   = "MyRDSMonitoringRole"
  create_monitoring_role = true

  tags = {
    Owner       = "mysql"
    Environment = "dev"
  }

  # DB subnet group
  create_db_subnet_group = true
  subnet_ids             = [module.vpc.private_subnets[0], module.vpc.private_subnets[1]]

  # DB parameter group
  family = "mysql5.7"

  # DB option group
  major_engine_version = "5.7"

  # Database Deletion Protection For Prod shloud be Set to True
  deletion_protection = false

  parameters = [
    {
      name  = "character_set_client"
      value = "utf8mb4"
    },
    {
      name  = "character_set_server"
      value = "utf8mb4"
    }
  ]

  options = [
    {
      option_name = "MARIADB_AUDIT_PLUGIN"

      option_settings = [
        {
          name  = "SERVER_AUDIT_EVENTS"
          value = "CONNECT"
        },
        {
          name  = "SERVER_AUDIT_FILE_ROTATIONS"
          value = "37"
        },
      ]
    },
  ]
}