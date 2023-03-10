resource "aws_ecs_cluster" "my_cluster" {
  name = "my_cluster"

  tags = {
    Name = "my_cluster"
  }
}
resource "aws_ecs_task_definition" "my_task" {
  family                   = "my_task"
  container_definitions    = jsonencode([{
    name            = "my-node-app"
    image           = "ahmedeldaly097/my-node-app:2.0"
    memory          = 256
    cpu             = 256
    portMappings    = [
      {
        containerPort = 80
        hostPort      = 80
      }
    ]
  }])

  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"

  tags = {
    Name = "my_task"
  }
}
resource "aws_ecs_service" "my_service" {
  name                  = "my_service"
  cluster               = aws_ecs_cluster.my_cluster.arn
  task_definition       = aws_ecs_task_definition.my_task.arn
  desired_count         = 1
  launch_type           = "FARGATE"
  platform_version      = "LATEST"

  network_configuration {
    subnets          = [
      aws_subnet.private_subnet_a.id,
      aws_subnet.private_subnet_b.id
    ]
    assign_public_ip = false
    security_groups  = [
      aws_security_group.ecs_sg.id
    ]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.my_target_group.arn
    container_name   = "my-node-app"
    container_port   = 80
  }

  tags = {
    Name = "my_service"
  }
}
resource "aws_security_group" "ecs_sg" {
  name_prefix = "ecs_sg_"
  vpc_id = aws_vpc.my_vpc.id
    ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [
      aws_security_group.lb_sg.id
    ]
  }

    egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
}
