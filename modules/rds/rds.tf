resource "aws_db_instance" "my_db" {
  allocated_storage    = 20
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  name                 = "my_db"
  username             = "my_user"
  password             = "my_password"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  vpc_security_group_ids = [
    aws_security_group.db_sg.id
  ]

  db_subnet_group_name = aws_db_subnet_group.my_db_subnet_group.name

  tags = {
    Name = "my_db"
  }
}
resource "aws_security_group" "db_sg" {
  name_prefix = "db_sg_"
  vpc_id = aws_vpc.my_vpc.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [
      aws_security_group.ecs_sg.id
    ]
  }

  tags = {
    Name = "db_sg"
  }
}
