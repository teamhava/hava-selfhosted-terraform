data "aws_rds_engine_version" "postgres" {
  engine  = "postgres"
  version = var.db_engine_version
}

resource "aws_db_parameter_group" "hava" {
  name   = "${var.name_prefix}-${random_string.suffix.result}"
  family = data.aws_rds_engine_version.postgres.parameter_group_family

  parameter {
    name  = "log_connections"
    value = "1"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_db_subnet_group" "hava" {
  name       = "${var.name_prefix}-db-${random_string.suffix.result}"
  subnet_ids = var.db_subnet_ids
}

resource "aws_security_group" "hava_db_sg" {
  name        = "${var.name_prefix}-db-${random_string.suffix.result}"
  description = "Allow connection from hava vm"
  vpc_id      = var.vpc_id

  ingress {
    description     = "postgresql"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.hava_sg.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_db_instance" "hava" {
  identifier                  = "${var.name_prefix}-db-${random_string.suffix.result}"
  allocated_storage           = 100
  db_name                     = "hava"
  engine                      = "postgres"
  engine_version              = var.db_engine_version
  instance_class              = var.db_instance_class
  username                    = "hava"
  manage_master_user_password = true
  parameter_group_name        = aws_db_parameter_group.hava.name
  skip_final_snapshot         = true
  db_subnet_group_name        = aws_db_subnet_group.hava.name
  vpc_security_group_ids      = [aws_security_group.hava_db_sg.id]
}
