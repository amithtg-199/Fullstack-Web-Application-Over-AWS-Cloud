module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = local.vpc.name
  cidr = local.vpc.cidr

  azs             = local.vpc.azs
  public_subnets  = local.vpc.public_subnets
  private_subnets  = local.vpc.private_subnets
  public_subnet_tags_per_az = local.vpc.public_subnet_tags_per_az
  private_subnet_tags_per_az = local.vpc.private_subnet_tags_per_az

  enable_vpn_gateway = false
  enable_nat_gateway = true
  one_nat_gateway_per_az = true
  single_nat_gateway = true

  tags = local.tags
  vpc_tags = local.vpc.tags
}