output "jumpserver_ssh" {
  value = "ssh -i ~/.ssh/ec2_rsa ubuntu@${module.front_end.public_ip}"
}

output "appserver_ssh" {
  value = "ssh -i ~/.ssh/ec2_rsa ubuntu@${module.backend_server.private_ip}"
}

output "alb_curl" {
  value = "curl http://${aws_lb.front_end.dns_name}"
}

output "rds_inst_address" {
  value = "curl http://${module.db.db_instance_address}"
}

output "rds_inst_identifier" {
  value = "curl http://${module.db.db_instance_identifier}"
}

output "rds_inst_name" {
  value = "curl http://${module.db.db_instance_name}"
}

output "rds_inst_port" {
  value = "curl http://${module.db.db_instance_port}"
}

output "rds_inst_username" {
  value = "curl http://${module.db.db_instance_username}"
  sensitive = true
}