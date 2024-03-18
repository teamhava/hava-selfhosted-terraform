output "instance_id" {
  description = "Instance ID of the Hava Instance"
  value       = aws_instance.hava.id
}

output "vm_ip" {
  description = "IP Address of the Hava Instance"
  value       = var.create_elastic_ip ? aws_eip.hava[0].public_ip : aws_instance.hava.public_ip
}

output "s3_bucket_name" {
  description = "Name of the Hava s3 bucket"
  value       = aws_s3_bucket.hava_cache[0].bucket
}

output "db_endpoint" {
  description = "Hava DB Endpoint"
  value       = aws_db_instance.hava.endpoint
}

output "db_name" {
  description = "Hava DB Name"
  value       = aws_db_instance.hava.db_name
}

output "db_user" {
  description = "Hava DB User"
  value       = aws_db_instance.hava.username
}
