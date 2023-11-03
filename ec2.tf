module "front_end" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  ami =  data.aws_ami.ubuntu.id
  name = "${var.prefix}-front_end"
  associate_public_ip_address = true
  instance_type          = var.server_instance_type
  key_name               = aws_key_pair.ssh_key.id
  monitoring             = true
  vpc_security_group_ids = [module.server_sg_public.security_group_id]
  subnet_id              = module.vpc.public_subnets[0]

  tags = {
    Terraform   = "true"
    Environment = "dev"
    Name = "${var.prefix}-front_end"
  }
  volume_tags = {
    Name = "${var.prefix}-front_end"
  }
}

module "backend_server" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  ami =  data.aws_ami.ubuntu.id
  name = "${var.prefix}-backend_server"
  instance_type          = var.server_instance_type
  key_name               = aws_key_pair.ssh_key.id
  monitoring             = true
  vpc_security_group_ids = [module.server_sg_private.security_group_id]
  subnet_id              = module.vpc.private_subnets[0]

  user_data = <<-EOF
  #!/bin/bash
  sudo apt update -y && sudo apt install -y apache2 \
                 ghostscript \
                 libapache2-mod-php \
                 php \
                 php-bcmath \
                 php-curl \
                 php-imagick \
                 php-intl \
                 php-json \
                 php-mbstring \
                 php-mysql \
                 php-xml \
                 php-zip
  EOF

  tags = {
    Terraform   = "true"
    Environment = "dev"
    Name = "${var.prefix}-backend_server"
  }
  volume_tags = {
    Name = "${var.prefix}-backend_server"
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-20.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}

resource "aws_key_pair" "ssh_key" {
  key_name   = "${var.prefix}-ssh_key"
  public_key = data.local_file.public_key.content
}

data "local_file" "public_key" {
  filename = "${path.module}/ec2_rsa.pub"
}