provider "aws" {
  region = "us-east-1"
}

locals {
  prefix = "hava-test" # prefix added to all named resources

  vpc_id       = "vpc-08a6b5a7fac2aa22f" # id of the VPC to deploy the resources to
  vm_subnet_id = "subnet-03920e6008d6a0213" # id of the subnet the VM will be deployed to
  instance_key = "tom-test" # name of the instance key to use to ssh to the vm

  # subnet ids for subnets that will host the postgres db, at least 2 subnets
  db_subnets = ["subnet-00a9d7cdc3b8b5021", "subnet-06c4ad5548edd127d", "subnet-02d2aeb5befac2002"]

  # tags that will be applied to all resources
  tags = {
    Environment = "test"
    Workload    = "Hava"
  }
}

resource "random_string" "sufix" {
  length  = 4
  lower = true
  upper = false
  numeric = false
  special = false
}

data "aws_ami" "debian" {
  most_recent = true

  filter {
    name   = "name"
    values = ["debian-11-amd64-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["679593333241"]
}

resource "aws_security_group" "hava_sg" {
  name        = "hava-sg"
  description = "Allow ssh and http traffic to Hava"
  vpc_id      = local.vpc_id

  ingress {
    description      = "Ssh"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "Hava web"
    from_port        = 9700
    to_port          = 9701
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "Allow ssl"
  }
}

resource "aws_iam_role" "hava" {
  name = "${local.prefix}-vm-role-${random_string.sufix.result}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "hava_car" {
  name = "${local.prefix}-car-${random_string.sufix.result}"
  path = "/"
  description = "Allow role to assume other roles"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = ["sts:AssumeRole"]
        Resource = ["*"]
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "hava_car" {
  name = "${local.prefix}-s3-${random_string.sufix.result}"
  roles = [aws_iam_role.hava.name]
  policy_arn = aws_iam_policy.hava_car.arn
}

resource "aws_iam_instance_profile" "hava_profile" {
  name = "${local.prefix}-vm-profile-${random_string.sufix.result}"
  role = aws_iam_role.hava.name
}

resource "aws_instance" "hava" {
  ami           = data.aws_ami.debian.id
  instance_type = "m5.xlarge"
  iam_instance_profile = aws_iam_instance_profile.hava_profile.name

  subnet_id = local.vm_subnet_id

  user_data = file("../vm_init.sh")

  key_name = local.instance_key

  vpc_security_group_ids = [aws_security_group.hava_sg.id]

  tags = local.tags

  root_block_device {
    volume_size = 200
    volume_type = "gp2"
    encrypted   = true
  }
}

terraform {
  required_version = "~> 1.3"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.9"
    }
    random = {
      source = "hashicorp/random"
      version = "~> 3.5"
    }
  }
}

output "vm_ip" {
  value = aws_instance.hava.public_ip
}