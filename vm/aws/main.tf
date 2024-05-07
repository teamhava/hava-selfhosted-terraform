terraform {
  required_version = "~> 1.3"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4"
    }
    time = {
      source  = "hashicorp/time"
      version = "~> 0.11"
    }
  }
}

provider "aws" {
  region = var.aws_region
  default_tags {
    tags = var.tags
  }
}

locals {
  docker_compose_file_b64 = base64encode(file("${path.module}/files/docker-compose.yaml"))
  docker_compose_env = {
    HAVA_IMAGE     = var.hava_image
    HAVA_VERSION   = var.hava_version
    API_PORT       = var.api_port
    WEBSOCKET_PORT = var.websocket_port
  }
  docker_compose_env_file     = join("\n", [for k, v in local.docker_compose_env : "${k}=${v}" if v != null])
  docker_compose_env_file_b64 = base64encode(local.docker_compose_env_file)

  hava_env = {

    HAVA_DOMAIN      = var.hava_domain
    COOKIE_DOMAIN    = var.cookie_domain
    HAVA_HOST        = var.hava_host
    API_SCHEME       = var.api_scheme
    API_HOST         = var.api_host
    API_PORT         = var.api_port
    WEBSOCKET_SCHEME = var.websocket_scheme
    WEBSOCKET_HOST   = var.websocket_host
    WEBSOCKET_PORT   = var.websocket_port
    WEBSOCKET_URL    = var.websocket_url

    SMTP_USER          = var.smtp_user
    SMTP_PASSWORD      = var.smtp_password
    SMTP_PORT          = var.smtp_port
    SMTP_DOMAIN        = var.smtp_domain
    EMAIL_FROM_ADDRESS = var.email_from_address
    EMAIL_FROM_NAME    = var.email_from_name

    CORS_ENABLED = var.cors_enabled
    CORS_HOSTS   = var.cors_hosts

    AUTO_SYNC_ENABLED = var.auto_sync_enabled
    AUTO_SYNC_COUNT   = var.auto_sync_count
    AUTO_SYNC_MINUTES = var.auto_sync_minutes

    SECRET_KEY  = var.secret_key
    ENCRYPT_IV  = coalesce(var.encrypt_iv, random_bytes.encrypt_iv[0].hex)
    ENCRYPT_KEY = coalesce(var.encrypt_key, random_bytes.encrypt_key[0].hex)

    PROVIDER_CAR_ENABLED     = var.provider_aws_car_enabled
    CAR_ACCOUNT_ID           = var.car_account_id
    CAR_USER_ACCESS_KEY      = var.car_user_access_key
    CAR_USER_SECRET_KEY      = var.car_user_secret_key
    CAR_USE_INSTANCE_PROFILE = var.car_use_instance_profile

    LOG_LEVEL = var.log_level

    RENDER_SCHEME                     = var.render_scheme
    RENDER_HOST                       = coalesce(var.render_host, var.api_host, var.hava_domain)
    RENDER_PORT                       = var.render_port
    RENDER_PATH                       = var.render_path
    RENDER_LOAD_SIGNING_KEY           = var.render_load_signing_key
    RENDER_LOAD_SIGNING_ID            = var.render_load_signing_id
    RENDER_STORAGE_TYPE               = var.create_s3_bucket ? "s3" : var.render_storage_type
    RENDER_STORAGE_LOCATION           = var.create_s3_bucket ? aws_s3_bucket.hava_cache[0].id : var.render_storage_location
    RENDER_STORAGE_REGION             = var.create_s3_bucket ? aws_s3_bucket.hava_cache[0].region : var.render_storage_region
    RENDER_STORAGE_PREFIX             = var.create_s3_bucket ? "render" : var.render_storage_prefix
    RENDER_CDN_ENABLED                = var.render_cdn_enabled ? true : null
    RENDER_CDN_TYPE                   = var.render_cdn_type
    RENDER_CDN_URI                    = var.render_cdn_uri
    RENDER_S3_ACCESS_KEY_ID           = var.render_s3_access_key_id
    RENDER_S3_SECRET_ACCESS_KEY       = var.render_s3_secret_access_key
    RENDER_S3_USE_INSTANCE_PROFILE    = var.create_s3_bucket ? true : var.render_s3_use_instance_profile
    RENDER_AZURE_STORAGE_ACCOUNT_NAME = var.render_azure_storage_account_name
    RENDER_AZURE_STORAGE_ACCESS_KEY   = var.render_azure_storage_access_key

    EMBEDDABLE_SCHEME           = var.embeddable_scheme
    EMBEDDABLE_HOST             = coalesce(var.embeddable_host, var.api_host, var.hava_domain)
    EMBEDDABLE_PORT             = var.embeddable_port
    EMBEDDABLE_PATH             = var.embeddable_path
    EMBEDDABLE_STORAGE_TYPE     = var.create_s3_bucket ? "s3" : var.embeddable_storage_type
    EMBEDDABLE_STORAGE_LOCATION = var.create_s3_bucket ? aws_s3_bucket.hava_cache[0].id : var.embeddable_storage_location
    EMBEDDABLE_STORAGE_REGION   = var.create_s3_bucket ? aws_s3_bucket.hava_cache[0].region : var.embeddable_storage_region
    EMBEDDABLE_STORAGE_PREFIX   = var.create_s3_bucket ? "embed" : var.embeddable_storage_prefix
    EMBEDDABLE_CDN_ENABLED      = var.embeddable_cdn_enabled ? true : null
    EMBEDDABLE_CDN_TYPE         = var.embeddable_cdn_type
    EMBEDDABLE_CDN_URI          = var.embeddable_cdn_uri
    EMBEDDABLE_LOAD_SIGNING_KEY = var.embeddable_load_signing_key
    EMBEDDABLE_LOAD_SIGNING_ID  = var.embeddable_load_signing_id

    HTTP_PROXY = var.http_proxy

    SSL_ENABLED = var.ssl_enabled
    SSL_CERT    = var.ssl_cert != null ? "/hava/ssl/ssl.crt" : null
    SSL_KEY     = var.ssl_key != null ? "/hava/ssl/ssl.key" : null
  }
  hava_env_file         = join("\n", [for k, v in local.hava_env : "${k}=${v}" if v != null])
  hava_env_file_b64     = base64encode(local.hava_env_file)
  hava_licence_file_b64 = base64encode(var.hava_licence)
  ssl_cert_b64          = var.ssl_cert != null ? base64encode(file(var.ssl_cert)) : ""
  ssl_key_b64           = var.ssl_key != null ? base64encode(file(var.ssl_key)) : ""
}

resource "random_string" "suffix" {
  length  = 4
  lower   = true
  upper   = false
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
  name        = "${var.name_prefix}-vm-${random_string.suffix.result}"
  description = "Allow ssh and http traffic to Hava"
  vpc_id      = var.vpc_id

  ingress {
    description      = "Ssh"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = var.ssh_ipv4_cidr_blocks
    ipv6_cidr_blocks = var.ssh_ipv6_cidr_blocks
  }

  dynamic "ingress" {
    for_each = distinct(toset([var.api_port, var.websocket_port, var.embeddable_port]))

    content {
      description      = "Hava"
      from_port        = ingress.value
      to_port          = ingress.value
      protocol         = "tcp"
      cidr_blocks      = var.hava_ipv4_cidr_blocks
      ipv6_cidr_blocks = var.hava_ipv6_cidr_blocks
    }
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${var.name_prefix}-vm-${random_string.suffix.result}"
  }
}

resource "aws_iam_role" "hava" {
  name = "${var.name_prefix}-vm-role-${random_string.suffix.result}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

data "aws_iam_policy_document" "hava_car_assume_role" {
  statement {
    effect    = "Allow"
    actions   = ["sts:AssumeRole"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "hava_car" {
  name        = "${var.name_prefix}-car-${random_string.suffix.result}"
  path        = "/"
  description = "Allow role to assume other roles"
  policy      = data.aws_iam_policy_document.hava_car_assume_role.json
}

resource "aws_iam_policy_attachment" "hava_car" {
  name       = "${var.name_prefix}-car-${random_string.suffix.result}"
  roles      = [aws_iam_role.hava.name]
  policy_arn = aws_iam_policy.hava_car.arn
}

data "aws_iam_policy_document" "hava_db_secret" {
  statement {
    effect    = "Allow"
    actions   = ["secretsmanager:GetSecretValue"]
    resources = [aws_db_instance.hava.master_user_secret[0].secret_arn]
  }
}

resource "aws_iam_policy" "hava_db_secret" {
  name        = "${var.name_prefix}-db-secret-${random_string.suffix.result}"
  path        = "/"
  description = "Allow access to Hava DB secret"
  policy      = data.aws_iam_policy_document.hava_db_secret.json
}

resource "aws_iam_policy_attachment" "hava_db_secret" {
  name       = "${var.name_prefix}-db-secret-${random_string.suffix.result}"
  roles      = [aws_iam_role.hava.name]
  policy_arn = aws_iam_policy.hava_db_secret.arn
}

resource "aws_iam_instance_profile" "hava_profile" {
  name = "${var.name_prefix}-vm-profile-${random_string.suffix.result}"
  role = aws_iam_role.hava.name

  depends_on = [
    aws_iam_policy_attachment.hava_db_secret,
  ]
}

resource "random_bytes" "encrypt_iv" {
  count  = var.encrypt_iv == null ? 1 : 0
  length = 8
}

resource "random_bytes" "encrypt_key" {
  count  = var.encrypt_key == null ? 1 : 0
  length = 48
}

resource "tls_private_key" "hava" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "hava" {
  key_name   = "${var.name_prefix}-key-${random_string.suffix.result}"
  public_key = tls_private_key.hava.public_key_openssh
}

resource "aws_instance" "hava" {
  ami                    = data.aws_ami.debian.id
  instance_type          = var.instance_type
  iam_instance_profile   = aws_iam_instance_profile.hava_profile.name
  subnet_id              = var.instance_subnet_id
  key_name               = aws_key_pair.hava.id
  vpc_security_group_ids = [aws_security_group.hava_sg.id]

  root_block_device {
    volume_size = var.root_volume_size
    volume_type = var.root_volume_type
    encrypted   = true
  }
}

resource "time_sleep" "instance_bootstrap" {
  create_duration = "120s"

  triggers = {
    instance_id = aws_instance.hava.id
  }
}

resource "terraform_data" "instance_bootstrap" {
  triggers_replace = [
    aws_instance.hava.id
  ]

  connection {
    type        = "ssh"
    user        = "admin"
    host        = var.create_elastic_ip ? aws_eip.hava[0].public_ip : aws_instance.hava.public_ip
    private_key = tls_private_key.hava.private_key_openssh
  }

  provisioner "remote-exec" {
    inline = [
      "set -e",
      "sudo apt-get update",
      "sudo apt-get install -y ca-certificates curl gnupg jq",
      "sudo install -m 0755 -d /etc/apt/keyrings",
      "sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc",
      "sudo chmod a+r /etc/apt/keyrings/docker.asc",
      "echo \"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian $(. /etc/os-release && echo \"$VERSION_CODENAME\") stable\" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null",
      "sudo apt-get update",
      "sudo apt-get -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin",
      "sudo usermod -aG docker admin",
      "sudo mkdir -p /hava",
      "sudo mkdir -p /hava/ssl",
      "sudo chown -R admin.admin /hava"
    ]
  }

  depends_on = [time_sleep.instance_bootstrap]
}

resource "time_sleep" "remote_exec" {
  create_duration = "30s"

  triggers = {
    instance_id = aws_instance.hava.id
  }

  depends_on = [terraform_data.instance_bootstrap]
}

resource "terraform_data" "hava_env_trigger" {
  input = {
    docker_compose_file_sha     = sha256(local.docker_compose_file_b64)
    docker_compose_env_file_sha = sha256(local.docker_compose_env_file_b64)
    hava_env_file_sha           = sha256(local.hava_env_file_b64)
    hava_licence_file_sha       = sha256(local.hava_licence_file_b64)
    ssl_cert_sha                = sha256(local.ssl_cert_b64)
    ssl_key_sha                 = sha256(local.ssl_key_b64)
  }
}

resource "terraform_data" "hava_env" {
  triggers_replace = [
    aws_instance.hava.id,
    aws_db_instance.hava.id,
    terraform_data.hava_env_trigger.output
  ]

  connection {
    type        = "ssh"
    user        = "admin"
    host        = var.create_elastic_ip ? aws_eip.hava[0].public_ip : aws_instance.hava.public_ip
    private_key = tls_private_key.hava.private_key_openssh
  }

  provisioner "remote-exec" {
    inline = [
      "echo \"${local.docker_compose_file_b64}\" | base64 -d > /hava/docker-compose.yaml", # write docker compose file
      "echo \"${local.docker_compose_env_file_b64}\" | base64 -d > /hava/.env",            # write .env file
      "echo \"${local.hava_env_file_b64}\" | base64 -d > /hava/hava.env",                  # write hava.env file
      "echo \"${local.hava_licence_file_b64}\" | base64 -d > /hava/hava.licence",          # write hava.licence file

      "echo \"DATABASE_URL=postgres://${aws_db_instance.hava.username}:$(aws secretsmanager get-secret-value --secret-id '${aws_db_instance.hava.master_user_secret[0].secret_arn}' --region ${var.aws_region} --query SecretString --output text | jq --raw-output '.password | @uri')@${aws_db_instance.hava.endpoint}/${aws_db_instance.hava.db_name}\" > /hava/hava_db.env", # write hava_db.env file

      var.ssl_cert != null ? "echo \"${local.ssl_cert_b64}\" | base64 -d > /hava/ssl/ssl.crt" : "true", # write ssl.crt file
      var.ssl_key != null ? "echo \"${local.ssl_key_b64}\" | base64 -d > /hava/ssl/ssl.key" : "true",   # write ssl.key file
    ]
  }

  depends_on = [time_sleep.remote_exec]
}


resource "terraform_data" "hava_bootstrap" {
  triggers_replace = [
    aws_instance.hava.id,
    aws_db_instance.hava.id
  ]

  connection {
    type        = "ssh"
    user        = "admin"
    host        = var.create_elastic_ip ? aws_eip.hava[0].public_ip : aws_instance.hava.public_ip
    private_key = tls_private_key.hava.private_key_openssh
  }

  provisioner "remote-exec" {
    inline = [
      "docker compose --progress plain --file /hava/docker-compose.yaml run hava hava exec rake db:setup",                                                   # run db:setup task
      "docker compose --progress plain --file /hava/docker-compose.yaml run hava hava exec rake es:index",                                                   # run es:index task
      "docker compose --progress plain --file /hava/docker-compose.yaml run hava hava accounts setup ${var.hava_licence_username} ${var.hava_licence_email}" # account setup
    ]
  }

  depends_on = [terraform_data.hava_env]
}

resource "terraform_data" "hava_upgrade_trigger" {
  input = {
    hava_image   = var.hava_image
    hava_version = var.hava_version
  }
}

resource "terraform_data" "hava_upgrade" {
  triggers_replace = [
    aws_instance.hava.id,
    terraform_data.hava_env.output,
    terraform_data.hava_upgrade_trigger.output
  ]

  connection {
    type        = "ssh"
    user        = "admin"
    host        = var.create_elastic_ip ? aws_eip.hava[0].public_ip : aws_instance.hava.public_ip
    private_key = tls_private_key.hava.private_key_openssh
  }

  provisioner "remote-exec" {
    inline = [
      "docker compose --progress plain --file /hava/docker-compose.yaml stop hava",                          # stop hava app
      "docker compose --progress plain --file /hava/docker-compose.yaml run hava hava exec rake db:migrate", # run db:migrate task
      "docker compose --progress plain --file /hava/docker-compose.yaml run hava ./price_import.sh",         # run price import
      "docker compose --progress plain --file /hava/docker-compose.yaml up -d"                               # start services
    ]
  }

  depends_on = [terraform_data.hava_bootstrap]
}

resource "aws_eip" "hava" {
  count    = var.create_elastic_ip ? 1 : 0
  instance = aws_instance.hava.id
  domain   = "vpc"
}

resource "aws_route53_record" "hava" {
  count   = var.create_route53_record ? 1 : 0
  name    = var.route53_record_name
  type    = "A"
  ttl     = 300
  zone_id = data.aws_route53_zone.hava[0].zone_id
  records = [var.create_elastic_ip ? aws_eip.hava[0].public_ip : aws_instance.hava.public_ip]
}

data "aws_route53_zone" "hava" {
  count = var.create_route53_record ? 1 : 0
  name  = var.route53_zone_name
}
