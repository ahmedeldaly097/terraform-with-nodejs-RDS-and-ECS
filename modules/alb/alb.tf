resource "aws_lb_target_group" "my_target_group" {
  name_prefix     = "my_target_group_"
  port            = 80
  protocol        = "HTTP"
  target_type     = "ip"
  vpc_id          = aws_vpc.my_vpc.id

  health_check {
    protocol     = "HTTP"
    path         = "/"
    matcher      = "200-299"
    interval     = 30
    timeout      = 10
    healthy_threshold = 2
    unhealthy_threshold = 5
  }

  tags = {
    Name = "my_target_group"
  }
}
resource "aws_lb" "my_lb" {
  name               = "my_lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [
    aws_security_group.lb_sg.id
  ]
  subnets = [
    aws_subnet.public_subnet_a.id,
    aws_subnet.public_subnet_b.id
  ]

  tags = {
    Name = "my_lb"
  }
}

resource "aws_lb_listener" "my_listener" {
  load_balancer_arn = aws_lb.my_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.my_target_group.arn
    type             = "forward"
  }

  depends_on = [
    aws_lb_target_group.my_target_group
  ]
}
