resource "random_password" "db_pass" {
  length           = 16
  special          = true
  min_lower        = 1
  min_numeric      = 1
  min_special      = 1
  min_upper        = 1
  override_special = "!"
}

resource "aws_db_parameter_group" "hava" {
  name   = "${local.prefix}-${random_string.sufix.result}"
  family = "postgres13"

  parameter {
    name  = "log_connections"
    value = "1"
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = local.tags
}

resource "aws_db_subnet_group" "hava" {
  name = "${local.prefix}-db-${random_string.sufix.result}"
  subnet_ids = local.db_subnets

  tags = local.tags
}

resource "aws_security_group" "hava_db_sg" {
  name = "${local.prefix}-db-${random_string.sufix.result}"
  description = "Allow connection from hava vm"
  vpc_id      = local.vpc_id

  ingress {
    description      = "postgresql"
    from_port        = 5432
    to_port          = 5432
    protocol         = "tcp"
    security_groups = [aws_security_group.hava_sg.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = local.tags
}

resource "aws_db_instance" "hava" {
  identifier           = "${local.prefix}-db-${random_string.sufix.result}"
  allocated_storage    = 100
  db_name              = "hava"
  engine               = "postgres"
  engine_version       = "13.10"
  instance_class       = "db.t3.medium"
  username             = "hava"
  password             = random_password.db_pass.result
  parameter_group_name = aws_db_parameter_group.hava.name
  skip_final_snapshot  = true
  db_subnet_group_name = aws_db_subnet_group.hava.name
  vpc_security_group_ids = [aws_security_group.hava_db_sg.id]

  tags = local.tags
}

output "db_pass" {
  value = random_password.db_pass.result
  sensitive = true
}

output "db_endpoint" {
  value = aws_db_instance.hava.endpoint
}

output "db_name" {
  value = aws_db_instance.hava.db_name
}

output "db_user" {
  value = aws_db_instance.hava.username
}

output "db_connection_string" {
  sensitive = true
  value = "postgres://${aws_db_instance.hava.username}:${random_password.db_pass.result}@${aws_db_instance.hava.endpoint}/${aws_db_instance.hava.db_name}"
}