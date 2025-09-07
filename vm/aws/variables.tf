variable "aws_region" {
  type        = string
  description = "AWS Region to deploy to"
  default     = "us-west-2"
}

variable "tags" {
  type        = map(string)
  description = "Tags to associate to each resource"
  default     = {}
}

variable "name_prefix" {
  type        = string
  description = "Prefix added to all named resources"
  default     = "hava"
}

variable "vpc_id" {
  type        = string
  description = "ID of the VPC do deploy the resources to"
}

variable "instance_subnet_id" {
  type        = string
  description = "ID of the Subnet the EC2 Instance will be deployed to"
}

variable "db_subnet_ids" {
  type        = list(string)
  description = "List of IDs of the Subnets to assicate to the RDS Instance"
}

variable "ssh_ipv4_cidr_blocks" {
  type        = list(string)
  description = "List of IPv4 CIDR blocks to allow SSH connections from"
  default     = ["0.0.0.0/0"]
}

variable "ssh_ipv6_cidr_blocks" {
  type        = list(string)
  description = "List of IPv6 CIDR blocks to allow SSH connections from"
  default     = ["::/0"]
}

variable "hava_ipv4_cidr_blocks" {
  type        = list(string)
  description = "List of IPv4 CIDR blocks to allow access to Hava"
  default     = ["0.0.0.0/0"]
}

variable "hava_ipv6_cidr_blocks" {
  type        = list(string)
  description = "List of IPv6 CIDR blocks to allow access to Hava"
  default     = ["::/0"]
}

variable "hava_image" {
  type        = string
  description = "Hava image name"
  default     = "hava/self-hosted"
}

variable "hava_version" {
  type        = string
  description = "Hava Version"
  default     = "2.3.877"
}

variable "hava_licence" {
  type        = string
  sensitive   = true
  description = "Hava licence"
}

variable "hava_licence_username" {
  type        = string
  description = "Hava username"
}

variable "hava_licence_email" {
  type        = string
  description = "Hava email"
}

variable "instance_type" {
  type        = string
  description = "Type of EC2 instance to deploy"
  default     = "m5.xlarge"
}

variable "root_volume_size" {
  type        = number
  description = "Size of the root block volume"
  default     = 200
}

variable "root_volume_type" {
  type        = string
  description = "Type of the root block volume"
  default     = "gp3"
}

variable "db_engine_version" {
  type        = string
  description = "PostgreSQL RDS engine version"
  default     = "15.14"
}

variable "db_instance_class" {
  type        = string
  description = "PostgreSQL RDS instance class"
  default     = "db.t3.medium"
}

variable "create_elastic_ip" {
  type        = bool
  description = "Create and assign an Elastic IP address to the EC2 instance"
  default     = false
}

variable "create_route53_record" {
  type        = bool
  description = "Create a Route 53 record for the EC2 instance"
  default     = false
}

variable "route53_zone_name" {
  type        = string
  description = "Route 53 Zone name, used when create_route53_record is true"
  default     = null
}

variable "route53_record_name" {
  type        = string
  description = "Name to use for Route 53 record"
  default     = "hava"
}

variable "hava_domain" {
  type        = string
  description = "Use this to set all the other host values in a single configuration point"
  default     = null
}

variable "cookie_domain" {
  type        = string
  description = "Domain used for cookies e.g. example.com"
  default     = null
}

variable "create_s3_bucket" {
  type        = bool
  description = "Create S3 bucket and configure hava to use this for storage"
  default     = true
}

variable "force_destroy_s3_bucket" {
  type        = bool
  description = "Should all objects within the s3 bucket be deleted when the bucket is destroyed"
  default     = false
}

variable "hava_host" {
  type        = string
  description = "Full URL of the endpoint that Hava is hosted on. (e.g. https://app.hava.io)"
  default     = null
}

variable "api_scheme" {
  type        = string
  description = "http or https"
  default     = "http"
}

variable "api_host" {
  type        = string
  description = "Host name used to send API requests to"
  default     = null
}

variable "api_port" {
  type        = number
  description = "Port for the API"
  default     = 9700
}

variable "websocket_scheme" {
  type        = string
  description = "http or https"
  default     = "http"
}

variable "websocket_host" {
  type        = string
  description = "Host name used to send API requests to"
  default     = null
}

variable "websocket_port" {
  type        = number
  description = "Port of the hava websocket"
  default     = 9701
}

variable "websocket_url" {
  type        = string
  description = "Full URL used by Pusher to send notifications to the user"
  default     = null
}

variable "smtp_user" {
  type        = string
  description = "The username to use to authenticate to the SMTP endpoint"
  default     = null
}

variable "smtp_password" {
  type        = string
  sensitive   = true
  description = "The password to use to authenticate to the SMTP endpoint"
  default     = null
}

variable "smtp_port" {
  type        = string
  description = "Port of the endpoint that Hava connects to send emails"
  default     = null
}

variable "smtp_domain" {
  type        = string
  description = "The domain of the endpoint that Hava connect to send emails"
  default     = null
}

variable "email_from_address" {
  type        = string
  description = "The email address that will be configured as the sender (e.g. noreply@hava.io)"
  default     = null
}

variable "email_from_name" {
  type        = string
  description = "The name that will be used as the sender (e.g. Team Hava)"
  default     = null
}

variable "cors_enabled" {
  type        = bool
  description = "Set to false to disable CORS validation"
  default     = true
}

variable "cors_hosts" {
  type        = string
  description = "Add additional hosts to the allowed host list for CORS. Comma delimited full URI. e.g. 'http://localhost:9700'"
  default     = null
}

variable "auto_sync_enabled" {
  type        = bool
  description = "Enables auto-sync of sources. Set to false to only support manual sync"
  default     = true
}

variable "auto_sync_count" {
  type        = number
  description = "Number of sync jobs to enqueue at the same time. High number will cause more spiky load"
  default     = 10
}

variable "auto_sync_minutes" {
  type        = number
  description = "Time in minutes between automated synchronizations of a source."
  default     = 1440
}

variable "secret_key" {
  type        = string
  sensitive   = true
  description = "Used to encrypt cookie data between the application and users"
  default     = null
}

variable "encrypt_key" {
  type        = string
  sensitive   = true
  description = "Used to encrypt source credentials in the database. Leave unset for auto-generated keys."
  default     = null
}

variable "encrypt_iv" {
  type        = string
  sensitive   = true
  description = "Used to encrypt source credentials in the database. Leave unset for auto-generated keys."
  default     = null
}

variable "provider_aws_car_enabled" {
  type        = bool
  description = "set to true to enable CAR"
  default     = false
}

variable "car_account_id" {
  type        = string
  description = "AWS Account ID for CAR"
  default     = null
}

variable "car_user_access_key" {
  type        = string
  sensitive   = true
  description = "AWS Access Key ID"
  default     = null
}

variable "car_user_secret_key" {
  type        = string
  sensitive   = true
  description = "AWS Secret Access Key"
  default     = null
}

variable "car_use_instance_profile" {
  type        = bool
  description = "Set to true to use an EC2 instance role instead of access key and secret key"
  default     = false
}

variable "log_level" {
  type        = string
  description = "level of the logs printed to output. Supported values: debug, info, warn, error"
  default     = "warn"
}

variable "render_scheme" {
  type        = string
  description = "Schema to use for render url. Accepts: http and https"
  default     = "http"
}

variable "render_host" {
  type        = string
  description = "Domain to use for the render url. Defaults to same domain as the API is running on"
  default     = null
}

variable "render_port" {
  type        = number
  description = "Port to use for render url"
  default     = 9700
}

variable "render_path" {
  type        = string
  description = "Path at the end of the url"
  default     = "/render"
}

variable "render_load_signing_key" {
  type        = string
  sensitive   = true
  description = "Signing key for creating a secure URL for S3 or CloudFront"
  default     = null
}

variable "render_load_signing_id" {
  type        = string
  sensitive   = true
  description = "Signing key id for creating secure URL for S3 or CloudFront"
  default     = null
}

variable "render_storage_type" {
  type        = string
  description = "The type of storage to use for render files. Supported values: filesystem, s3"
  default     = "filesystem"
}

variable "render_storage_location" {
  type        = string
  description = "The location where the files are written. When type is filesystem, this is the path on the local system. When type is s3, this is the name of the S3 bucket"
  default     = "/data/render"
}

variable "render_storage_region" {
  type        = string
  description = "The region the storage is located in, this is only used if type is S3"
  default     = null
}

variable "render_storage_prefix" {
  type        = string
  description = "A prefix that is added to the path where the files are stored. e.g. in S3 it becomes bucket/prefix/filename"
  default     = null
}

variable "render_cdn_enabled" {
  type        = bool
  description = "Enabled CDN for render files, set to true to enable"
  default     = false
}

variable "render_cdn_type" {
  type        = string
  description = "The type of CDN. Supported values: cloudfront"
  default     = null
}

variable "render_cdn_uri" {
  type        = string
  description = "url for the cloudfront endpoint"
  default     = null
}

variable "render_s3_access_key_id" {
  type        = string
  sensitive   = true
  description = "AWS Access key for accessing the S3 bucket"
  default     = null
}

variable "render_s3_secret_access_key" {
  type        = string
  sensitive   = true
  description = "AWS secret access key for accessing the s3 bucket"
  default     = null
}

variable "render_s3_use_instance_profile" {
  type        = bool
  description = "Set to true to use an instance profile to access the S3 bucket instead of long lived credentials"
  default     = false
}

variable "render_azure_storage_account_name" {
  type        = string
  description = "If RENDER_STORAGE_TYPE is azure-blob use this variable to set the azure storage account name"
  default     = null
}

variable "render_azure_storage_access_key" {
  type        = string
  sensitive   = true
  description = "If RENDER_STORAGE_TYPE is azure-blob use this variable to set the azure storage account access key"
  default     = null
}

variable "embeddable_scheme" {
  type        = string
  description = "Schema to use for embed url. Accepts: http and https"
  default     = "http"
}

variable "embeddable_host" {
  type        = string
  description = "Domain to use for the embedded url. Defaults to same domain as the API is running on"
  default     = null
}

variable "embeddable_port" {
  type        = number
  description = "Port to use for embed url"
  default     = 9700
}

variable "embeddable_path" {
  type        = string
  description = "Path at the end of the url"
  default     = "/embed"
}

variable "embeddable_storage_type" {
  type        = string
  description = "The type of storage to use for embedded files. Supported values: filesystem, s3"
  default     = "filesystem"
}

variable "embeddable_storage_location" {
  type        = string
  description = "The location where the files are written. When type is filesystem, this is the path on the local system. When type is s3, this is the name of the S3 bucket"
  default     = "/data/embed"
}

variable "embeddable_storage_region" {
  type        = string
  description = "The region the storage is located in, this is only used if type is S3"
  default     = null
}

variable "embeddable_storage_prefix" {
  type        = string
  description = "A prefix that is added to the path where the files are stored. e.g. in S3 it becomes bucket/prefix/filename"
  default     = null
}

variable "embeddable_cdn_enabled" {
  type        = bool
  description = "Enabled CDN for embedded files, set to true to enable"
  default     = false
}

variable "embeddable_cdn_type" {
  type        = string
  description = "The type of CDN. Supported Values: cloudfront"
  default     = null
}

variable "embeddable_cdn_uri" {
  type        = string
  description = "url for the cloudfront endpoint"
  default     = null
}

variable "embeddable_load_signing_key" {
  type        = string
  sensitive   = true
  description = "Signing key for creating a secure URL for S3 or CloudFront"
  default     = null
}

variable "embeddable_load_signing_id" {
  type        = string
  sensitive   = true
  description = "Signing key id for creating secure URL for S3 or CloudFront"
  default     = null
}

variable "http_proxy" {
  type        = string
  description = "Use to set a proxy address that the workers will use to connect to external services"
  default     = null
}

variable "ssl_enabled" {
  type        = bool
  description = "Set to true to enable SSL configuration"
  default     = false
}

variable "ssl_cert" {
  type        = string
  description = "Path to the certificate file on the local file system, should be an absolute path"
  default     = null
}

variable "ssl_key" {
  type        = string
  description = "Path to the key file on the local file system, should be an absolute path"
  default     = null
}
