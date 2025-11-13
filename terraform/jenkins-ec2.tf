resource "aws_instance" "jenkins" {
  ami           = "ami-0c6ef28989b434b51" # Ubuntu 22.04 in ap-south-2
  instance_type = "t3.micro"
  key_name      = "devops-key"
  
  subnet_id = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.hotel_sg.id]

  tags = {
    Name = "jenkins-server"
  }
}

# Optional Output
output "jenkins_public_ip" {
  description = "Public IP of Jenkins EC2 instance"
  value       = aws_instance.jenkins.public_ip
}