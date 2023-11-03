locals {
  vpc = {
    name           = "${var.prefix}-main"
    cidr           = "10.0.0.0/16"
    azs            = ["${var.region}${var.subnet1_zone}", "${var.region}${var.subnet2_zone}"]
    public_subnets = ["10.0.0.0/24", "10.0.1.0/24"]
    private_subnets = ["10.0.101.0/24", "10.0.102.0/24"]
    public_subnet_tags_per_az = {
      "${var.region}${var.subnet1_zone}" = {
        Name = "${var.prefix}-public_${var.subnet1_zone}"
      }
      "${var.region}${var.subnet2_zone}" = {
        Name = "${var.prefix}-public_${var.subnet2_zone}"
      }
    }
    private_subnet_tags_per_az = {
      "${var.region}${var.subnet1_zone}" = {
        Name = "${var.prefix}-private_${var.subnet1_zone}"
      }
      "${var.region}${var.subnet2_zone}" = {
        Name = "${var.prefix}-private_${var.subnet2_zone}"
      }
    }
    tags = {
      Name = "${var.prefix}-main"
    }
  }
  tags = {
    # put key/value for any tags you want added to all resources generated by this TF project
  }

}