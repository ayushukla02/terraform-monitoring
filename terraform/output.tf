output "instance_type" {
  value       = aws_instance.devops_instance.instance_type
  description = "The instance type used to launch the instance"
}

output "instance_image" {
  value       = aws_instance.devops_instance.ami
  description = "The AMI ID used to launch the instance"
}

output "instance_public_ip" {
  value       = aws_instance.devops_instance.public_ip
  description = "The public IP of the instance"
}

output "s3_bucket_name" {
  value       = aws_s3_bucket.devops_bucket.bucket
  description = "The name of the S3 bucket"
}
