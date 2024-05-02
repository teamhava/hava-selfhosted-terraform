# Hava AWS VM Terraform Module

Terraform module to deploy Hava Self-Hosted in AWS on a single VM

## Example Usage

```hcl
variable "hava_image" {
  type = string
}

variable "hava_version" {
  type = string
}

variable "hava_licence" {
  type = string
}

variable "hava_licence_username" {
  type = string
}

variable "hava_licence_email" {
  type = string
}

module "self_hosted_vm" {
  source = "github.com/teamhava/hava-selfhosted-terraform//vm/aws"

  hava_image              = var.hava_image
  hava_version            = var.hava_version
  hava_licence            = var.hava_licence
  hava_licence_username   = var.hava_licence_username
  hava_licence_email      = var.hava_licence_email
  create_elastic_ip       = true
  create_route53_record   = true
  create_s3_bucket        = true
  force_destroy_s3_bucket = true
  aws_region              = "us-east-1"
  route53_zone_name       = "testing.hava.io"
  route53_record_name     = "self-hosted-vm"
  hava_domain             = "self-hosted-vm.testing.hava.io"
  name_prefix             = "self-hosted-vm"
  vpc_id                  = "vpc-08a6b5a7fac2aa22f"
  instance_subnet_id      = "subnet-03920e6008d6a0213"
  db_subnet_ids           = ["subnet-00a9d7cdc3b8b5021", "subnet-06c4ad5548edd127d"]
  tags = {
    Environment = "test"
    Workload    = "Hava"
  }
}
```


<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3 |
| <a name="requirement_time"></a> [time](#requirement\_time) | ~> 0.11 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | ~> 4 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5 |
| <a name="provider_random"></a> [random](#provider\_random) | ~> 3 |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |
| <a name="provider_time"></a> [time](#provider\_time) | ~> 0.11 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | ~> 4 |

## Resources

| Name | Type |
|------|------|
| [aws_db_instance.hava](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance) | resource |
| [aws_db_parameter_group.hava](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_parameter_group) | resource |
| [aws_db_subnet_group.hava](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group) | resource |
| [aws_eip.hava](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_iam_instance_profile.hava_profile](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_policy.hava_cache_s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.hava_car](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.hava_db_secret](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy_attachment.hava_cache_s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy_attachment) | resource |
| [aws_iam_policy_attachment.hava_car](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy_attachment) | resource |
| [aws_iam_policy_attachment.hava_db_secret](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy_attachment) | resource |
| [aws_iam_role.hava](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_instance.hava](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_key_pair.hava](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair) | resource |
| [aws_route53_record.hava](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_s3_bucket.hava_cache](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_security_group.hava_db_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.hava_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [random_bytes.encrypt_iv](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/bytes) | resource |
| [random_bytes.encrypt_key](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/bytes) | resource |
| [random_string.suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [terraform_data.hava_bootstrap](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/resources/data) | resource |
| [terraform_data.hava_env](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/resources/data) | resource |
| [terraform_data.hava_env_trigger](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/resources/data) | resource |
| [terraform_data.hava_upgrade](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/resources/data) | resource |
| [terraform_data.hava_upgrade_trigger](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/resources/data) | resource |
| [time_sleep.remote_exec](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [tls_private_key.hava](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [aws_ami.debian](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_iam_policy_document.hava_car_assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.hava_db_secret](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_rds_engine_version.postgres](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/rds_engine_version) | data source |
| [aws_route53_zone.hava](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_api_host"></a> [api\_host](#input\_api\_host) | Host name used to send API requests to | `string` | `null` | no |
| <a name="input_api_port"></a> [api\_port](#input\_api\_port) | Port for the API | `number` | `9700` | no |
| <a name="input_api_scheme"></a> [api\_scheme](#input\_api\_scheme) | http or https | `string` | `"http"` | no |
| <a name="input_auto_sync_count"></a> [auto\_sync\_count](#input\_auto\_sync\_count) | Number of sync jobs to enqueue at the same time. High number will cause more spiky load | `number` | `10` | no |
| <a name="input_auto_sync_enabled"></a> [auto\_sync\_enabled](#input\_auto\_sync\_enabled) | Enables auto-sync of sources. Set to false to only support manual sync | `bool` | `true` | no |
| <a name="input_auto_sync_minutes"></a> [auto\_sync\_minutes](#input\_auto\_sync\_minutes) | Time in minutes between automated synchronizations of a source. | `number` | `1440` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS Region to deploy to | `string` | `"us-west-2"` | no |
| <a name="input_car_account_id"></a> [car\_account\_id](#input\_car\_account\_id) | AWS Account ID for CAR | `string` | `null` | no |
| <a name="input_car_use_instance_profile"></a> [car\_use\_instance\_profile](#input\_car\_use\_instance\_profile) | Set to true to use an EC2 instance role instead of access key and secret key | `bool` | `false` | no |
| <a name="input_car_user_access_key"></a> [car\_user\_access\_key](#input\_car\_user\_access\_key) | AWS Access Key ID | `string` | `null` | no |
| <a name="input_car_user_secret_key"></a> [car\_user\_secret\_key](#input\_car\_user\_secret\_key) | AWS Secret Access Key | `string` | `null` | no |
| <a name="input_cookie_domain"></a> [cookie\_domain](#input\_cookie\_domain) | Domain used for cookies e.g. example.com | `string` | `null` | no |
| <a name="input_cors_enabled"></a> [cors\_enabled](#input\_cors\_enabled) | Set to false to disable CORS validation | `bool` | `true` | no |
| <a name="input_cors_hosts"></a> [cors\_hosts](#input\_cors\_hosts) | Add additional hosts to the allowed host list for CORS. Comma delimited full URI. e.g. 'http://localhost:9700' | `string` | `null` | no |
| <a name="input_create_elastic_ip"></a> [create\_elastic\_ip](#input\_create\_elastic\_ip) | Create and assign an Elastic IP address to the EC2 instance | `bool` | `false` | no |
| <a name="input_create_route53_record"></a> [create\_route53\_record](#input\_create\_route53\_record) | Create a Route 53 record for the EC2 instance | `bool` | `false` | no |
| <a name="input_create_s3_bucket"></a> [create\_s3\_bucket](#input\_create\_s3\_bucket) | Create S3 bucket and configure hava to use this for storage | `bool` | `true` | no |
| <a name="input_db_engine_version"></a> [db\_engine\_version](#input\_db\_engine\_version) | PostgreSQL RDS engine version | `string` | `"15.6"` | no |
| <a name="input_db_instance_class"></a> [db\_instance\_class](#input\_db\_instance\_class) | PostgreSQL RDS instance class | `string` | `"db.t3.medium"` | no |
| <a name="input_db_subnet_ids"></a> [db\_subnet\_ids](#input\_db\_subnet\_ids) | List of IDs of the Subnets to assicate to the RDS Instance | `list(string)` | n/a | yes |
| <a name="input_email_from_address"></a> [email\_from\_address](#input\_email\_from\_address) | The email address that will be configured as the sender (e.g. noreply@hava.io) | `string` | `null` | no |
| <a name="input_email_from_name"></a> [email\_from\_name](#input\_email\_from\_name) | The name that will be used as the sender (e.g. Team Hava) | `string` | `null` | no |
| <a name="input_embeddable_cdn_enabled"></a> [embeddable\_cdn\_enabled](#input\_embeddable\_cdn\_enabled) | Enabled CDN for embedded files, set to true to enable | `bool` | `false` | no |
| <a name="input_embeddable_cdn_type"></a> [embeddable\_cdn\_type](#input\_embeddable\_cdn\_type) | The type of CDN. Supported Values: cloudfront | `string` | `null` | no |
| <a name="input_embeddable_cdn_uri"></a> [embeddable\_cdn\_uri](#input\_embeddable\_cdn\_uri) | url for the cloudfront endpoint | `string` | `null` | no |
| <a name="input_embeddable_host"></a> [embeddable\_host](#input\_embeddable\_host) | Domain to use for the embedded url. Defaults to same domain as the API is running on | `string` | `null` | no |
| <a name="input_embeddable_load_signing_id"></a> [embeddable\_load\_signing\_id](#input\_embeddable\_load\_signing\_id) | Signing key id for creating secure URL for S3 or CloudFront | `string` | `null` | no |
| <a name="input_embeddable_load_signing_key"></a> [embeddable\_load\_signing\_key](#input\_embeddable\_load\_signing\_key) | Signing key for creating a secure URL for S3 or CloudFront | `string` | `null` | no |
| <a name="input_embeddable_path"></a> [embeddable\_path](#input\_embeddable\_path) | Path at the end of the url | `string` | `"/embed"` | no |
| <a name="input_embeddable_port"></a> [embeddable\_port](#input\_embeddable\_port) | Port to use for embed url | `number` | `9700` | no |
| <a name="input_embeddable_scheme"></a> [embeddable\_scheme](#input\_embeddable\_scheme) | Schema to use for embed url. Accepts: http and https | `string` | `"http"` | no |
| <a name="input_embeddable_storage_location"></a> [embeddable\_storage\_location](#input\_embeddable\_storage\_location) | The location where the files are written. When type is filesystem, this is the path on the local system. When type is s3, this is the name of the S3 bucket | `string` | `"/data/embed"` | no |
| <a name="input_embeddable_storage_prefix"></a> [embeddable\_storage\_prefix](#input\_embeddable\_storage\_prefix) | A prefix that is added to the path where the files are stored. e.g. in S3 it becomes bucket/prefix/filename | `string` | `null` | no |
| <a name="input_embeddable_storage_region"></a> [embeddable\_storage\_region](#input\_embeddable\_storage\_region) | The region the storage is located in, this is only used if type is S3 | `string` | `null` | no |
| <a name="input_embeddable_storage_type"></a> [embeddable\_storage\_type](#input\_embeddable\_storage\_type) | The type of storage to use for embedded files. Supported values: filesystem, s3 | `string` | `"filesystem"` | no |
| <a name="input_encrypt_iv"></a> [encrypt\_iv](#input\_encrypt\_iv) | Used to encrypt source credentials in the database. Leave unset for auto-generated keys. | `string` | `null` | no |
| <a name="input_encrypt_key"></a> [encrypt\_key](#input\_encrypt\_key) | Used to encrypt source credentials in the database. Leave unset for auto-generated keys. | `string` | `null` | no |
| <a name="input_force_destroy_s3_bucket"></a> [force\_destroy\_s3\_bucket](#input\_force\_destroy\_s3\_bucket) | Should all objects within the s3 bucket be deleted when the bucket is destroyed | `bool` | `false` | no |
| <a name="input_hava_domain"></a> [hava\_domain](#input\_hava\_domain) | Use this to set all the other host values in a single configuration point | `string` | `null` | no |
| <a name="input_hava_host"></a> [hava\_host](#input\_hava\_host) | Full URL of the endpoint that Hava is hosted on. (e.g. https://app.hava.io) | `string` | `null` | no |
| <a name="input_hava_image"></a> [hava\_image](#input\_hava\_image) | Hava image name | `string` | `"hava/self-hosted"` | no |
| <a name="input_hava_ipv4_cidr_blocks"></a> [hava\_ipv4\_cidr\_blocks](#input\_hava\_ipv4\_cidr\_blocks) | List of IPv4 CIDR blocks to allow access to Hava | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| <a name="input_hava_ipv6_cidr_blocks"></a> [hava\_ipv6\_cidr\_blocks](#input\_hava\_ipv6\_cidr\_blocks) | List of IPv6 CIDR blocks to allow access to Hava | `list(string)` | <pre>[<br>  "::/0"<br>]</pre> | no |
| <a name="input_hava_licence"></a> [hava\_licence](#input\_hava\_licence) | Hava licence | `string` | n/a | yes |
| <a name="input_hava_licence_email"></a> [hava\_licence\_email](#input\_hava\_licence\_email) | Hava email | `string` | n/a | yes |
| <a name="input_hava_licence_username"></a> [hava\_licence\_username](#input\_hava\_licence\_username) | Hava username | `string` | n/a | yes |
| <a name="input_hava_version"></a> [hava\_version](#input\_hava\_version) | Hava Version | `string` | `"2.3.877"` | no |
| <a name="input_http_proxy"></a> [http\_proxy](#input\_http\_proxy) | Use to set a proxy address that the workers will use to connect to external services | `string` | `null` | no |
| <a name="input_instance_subnet_id"></a> [instance\_subnet\_id](#input\_instance\_subnet\_id) | ID of the Subnet the EC2 Instance will be deployed to | `string` | n/a | yes |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Type of EC2 instance to deploy | `string` | `"m5.xlarge"` | no |
| <a name="input_log_level"></a> [log\_level](#input\_log\_level) | level of the logs printed to output. Supported values: debug, info, warn, error | `string` | `"warn"` | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | Prefix added to all named resources | `string` | `"hava"` | no |
| <a name="input_provider_aws_car_enabled"></a> [provider\_aws\_car\_enabled](#input\_provider\_aws\_car\_enabled) | set to true to enable CAR | `bool` | `false` | no |
| <a name="input_render_azure_storage_access_key"></a> [render\_azure\_storage\_access\_key](#input\_render\_azure\_storage\_access\_key) | If RENDER\_STORAGE\_TYPE is azure-blob use this variable to set the azure storage account access key | `string` | `null` | no |
| <a name="input_render_azure_storage_account_name"></a> [render\_azure\_storage\_account\_name](#input\_render\_azure\_storage\_account\_name) | If RENDER\_STORAGE\_TYPE is azure-blob use this variable to set the azure storage account name | `string` | `null` | no |
| <a name="input_render_cdn_enabled"></a> [render\_cdn\_enabled](#input\_render\_cdn\_enabled) | Enabled CDN for render files, set to true to enable | `bool` | `false` | no |
| <a name="input_render_cdn_type"></a> [render\_cdn\_type](#input\_render\_cdn\_type) | The type of CDN. Supported values: cloudfront | `string` | `null` | no |
| <a name="input_render_cdn_uri"></a> [render\_cdn\_uri](#input\_render\_cdn\_uri) | url for the cloudfront endpoint | `string` | `null` | no |
| <a name="input_render_host"></a> [render\_host](#input\_render\_host) | Domain to use for the render url. Defaults to same domain as the API is running on | `string` | `null` | no |
| <a name="input_render_load_signing_id"></a> [render\_load\_signing\_id](#input\_render\_load\_signing\_id) | Signing key id for creating secure URL for S3 or CloudFront | `string` | `null` | no |
| <a name="input_render_load_signing_key"></a> [render\_load\_signing\_key](#input\_render\_load\_signing\_key) | Signing key for creating a secure URL for S3 or CloudFront | `string` | `null` | no |
| <a name="input_render_path"></a> [render\_path](#input\_render\_path) | Path at the end of the url | `string` | `"/render"` | no |
| <a name="input_render_port"></a> [render\_port](#input\_render\_port) | Port to use for render url | `number` | `9700` | no |
| <a name="input_render_s3_access_key_id"></a> [render\_s3\_access\_key\_id](#input\_render\_s3\_access\_key\_id) | AWS Access key for accessing the S3 bucket | `string` | `null` | no |
| <a name="input_render_s3_secret_access_key"></a> [render\_s3\_secret\_access\_key](#input\_render\_s3\_secret\_access\_key) | AWS secret access key for accessing the s3 bucket | `string` | `null` | no |
| <a name="input_render_s3_use_instance_profile"></a> [render\_s3\_use\_instance\_profile](#input\_render\_s3\_use\_instance\_profile) | Set to true to use an instance profile to access the S3 bucket instead of long lived credentials | `bool` | `false` | no |
| <a name="input_render_scheme"></a> [render\_scheme](#input\_render\_scheme) | Schema to use for render url. Accepts: http and https | `string` | `"http"` | no |
| <a name="input_render_storage_location"></a> [render\_storage\_location](#input\_render\_storage\_location) | The location where the files are written. When type is filesystem, this is the path on the local system. When type is s3, this is the name of the S3 bucket | `string` | `"/data/render"` | no |
| <a name="input_render_storage_prefix"></a> [render\_storage\_prefix](#input\_render\_storage\_prefix) | A prefix that is added to the path where the files are stored. e.g. in S3 it becomes bucket/prefix/filename | `string` | `null` | no |
| <a name="input_render_storage_region"></a> [render\_storage\_region](#input\_render\_storage\_region) | The region the storage is located in, this is only used if type is S3 | `string` | `null` | no |
| <a name="input_render_storage_type"></a> [render\_storage\_type](#input\_render\_storage\_type) | The type of storage to use for render files. Supported values: filesystem, s3 | `string` | `"filesystem"` | no |
| <a name="input_root_volume_size"></a> [root\_volume\_size](#input\_root\_volume\_size) | Size of the root block volume | `number` | `200` | no |
| <a name="input_root_volume_type"></a> [root\_volume\_type](#input\_root\_volume\_type) | Type of the root block volume | `string` | `"gp3"` | no |
| <a name="input_route53_record_name"></a> [route53\_record\_name](#input\_route53\_record\_name) | Name to use for Route 53 record | `string` | `"hava"` | no |
| <a name="input_route53_zone_name"></a> [route53\_zone\_name](#input\_route53\_zone\_name) | Route 53 Zone name, used when create\_route53\_record is true | `string` | `null` | no |
| <a name="input_secret_key"></a> [secret\_key](#input\_secret\_key) | Used to encrypt cookie data between the application and users | `string` | `null` | no |
| <a name="input_smtp_domain"></a> [smtp\_domain](#input\_smtp\_domain) | The domain of the endpoint that Hava connect to send emails | `string` | `null` | no |
| <a name="input_smtp_password"></a> [smtp\_password](#input\_smtp\_password) | The password to use to authenticate to the SMTP endpoint | `string` | `null` | no |
| <a name="input_smtp_port"></a> [smtp\_port](#input\_smtp\_port) | Port of the endpoint that Hava connects to send emails | `string` | `null` | no |
| <a name="input_smtp_user"></a> [smtp\_user](#input\_smtp\_user) | The username to use to authenticate to the SMTP endpoint | `string` | `null` | no |
| <a name="input_ssh_ipv4_cidr_blocks"></a> [ssh\_ipv4\_cidr\_blocks](#input\_ssh\_ipv4\_cidr\_blocks) | List of IPv4 CIDR blocks to allow SSH connections from | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| <a name="input_ssh_ipv6_cidr_blocks"></a> [ssh\_ipv6\_cidr\_blocks](#input\_ssh\_ipv6\_cidr\_blocks) | List of IPv6 CIDR blocks to allow SSH connections from | `list(string)` | <pre>[<br>  "::/0"<br>]</pre> | no |
| <a name="input_ssl_cert"></a> [ssl\_cert](#input\_ssl\_cert) | Path to the certificate file on the local file system, should be an absolute path | `string` | `null` | no |
| <a name="input_ssl_enabled"></a> [ssl\_enabled](#input\_ssl\_enabled) | Set to true to enable SSL configuration | `bool` | `false` | no |
| <a name="input_ssl_key"></a> [ssl\_key](#input\_ssl\_key) | Path to the key file on the local file system, should be an absolute path | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to associate to each resource | `map(string)` | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | ID of the VPC do deploy the resources to | `string` | n/a | yes |
| <a name="input_websocket_host"></a> [websocket\_host](#input\_websocket\_host) | Host name used to send API requests to | `string` | `null` | no |
| <a name="input_websocket_port"></a> [websocket\_port](#input\_websocket\_port) | Port of the hava websocket | `number` | `9701` | no |
| <a name="input_websocket_scheme"></a> [websocket\_scheme](#input\_websocket\_scheme) | http or https | `string` | `"http"` | no |
| <a name="input_websocket_url"></a> [websocket\_url](#input\_websocket\_url) | Full URL used by Pusher to send notifications to the user | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_db_endpoint"></a> [db\_endpoint](#output\_db\_endpoint) | Hava DB Endpoint |
| <a name="output_db_name"></a> [db\_name](#output\_db\_name) | Hava DB Name |
| <a name="output_db_user"></a> [db\_user](#output\_db\_user) | Hava DB User |
| <a name="output_instance_id"></a> [instance\_id](#output\_instance\_id) | Instance ID of the Hava Instance |
| <a name="output_instance_ip"></a> [instance\_ip](#output\_instance\_ip) | IP Address of the Hava Instance |
| <a name="output_instance_ssh_private_key"></a> [instance\_ssh\_private\_key](#output\_instance\_ssh\_private\_key) | Instance SSH Private Key |
| <a name="output_instance_ssh_user"></a> [instance\_ssh\_user](#output\_instance\_ssh\_user) | Instance SSH Username |
| <a name="output_s3_bucket_name"></a> [s3\_bucket\_name](#output\_s3\_bucket\_name) | Name of the Hava s3 bucket |
<!-- END_TF_DOCS -->