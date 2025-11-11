output "ec2_public_ip" {
  description = "Public IP of EC2 instance"
  value       = aws_instance.hotel_ec2.public_ip
}

output "ecr_repo_url" {
  description = "ECR Repository URL"
  value       = aws_ecr_repository.hotel_ecr.repository_url
}
