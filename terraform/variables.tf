variable "aws_region" {
  default = "ap-south-2"
}

variable "instance_type" {
  default = "t3.micro"
}

variable "key_name" {
  description = "Key pair name for EC2 SSH access"
  default     = "devops-key"
}
