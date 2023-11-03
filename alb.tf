resource "aws_lb" "front_end" {
  name               = "${var.prefix}-front-end"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [module.alb-sg.security_group_id]
  # subnets            = [aws_subnet.public_a.id, aws_subnet.public_c.id]
  subnets = module.vpc.public_subnets
  enable_deletion_protection = false
}

resource "aws_lb_target_group" "front_end" {
  name     = "${var.prefix}-front-end"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id
}

resource "aws_alb_listener" "front_end" {
  load_balancer_arn = aws_lb.front_end.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.front_end.arn
  }
}

resource "aws_alb_target_group_attachment" "app_instance" {
  target_group_arn = aws_lb_target_group.front_end.arn
  target_id        = module.backend_server.id
  port             = 80
}
