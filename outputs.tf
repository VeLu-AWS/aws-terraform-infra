output "ec2_instance_id" {
  description = "EC2 Instance ID"
  value       = aws_instance.railman_server.id
}

output "ec2_public_ip" {
  description = "Elastic IP of Railman server"
  value       = aws_eip.railman_eip.public_ip
}

output "ec2_private_ip" {
  description = "Private IP of Railman server"
  value       = aws_instance.railman_server.private_ip
}

output "s3_bucket_name" {
  description = "S3 bucket name for railway data"
  value       = aws_s3_bucket.railway_data.bucket
}

output "s3_bucket_arn" {
  description = "S3 bucket ARN"
  value       = aws_s3_bucket.railway_data.arn
}

output "security_group_id" {
  description = "Security Group ID"
  value       = aws_security_group.railman_sg.id
}
