module "server_sg_public" {
  source = "terraform-aws-modules/security-group/aws//modules/http-80"

  name        = "${var.prefix}-server"
  description = "Allow ssh and http inbound traffic"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules = ["ssh-tcp"]
  egress_rules = ["all-all"]
}

module "server_sg_private" {
  source = "terraform-aws-modules/security-group/aws//modules/http-80"

  name        = "${var.prefix}-server"
  description = "Allow ssh and http inbound traffic"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = local.vpc.cidr
  ingress_rules = ["ssh-tcp"]
  egress_rules = ["all-all"]
}

module "alb-sg" {
  source = "terraform-aws-modules/security-group/aws//modules/http-80"

  name        = "${var.prefix}-alb"
  description = "Allow ssh and http inbound traffic"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules = ["all-all"]
}