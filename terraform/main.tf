# ----- VPC -----
resource "aws_vpc" "hotel_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "hotel-vpc"
  }
}

# ----- Subnet -----
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.hotel_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-south-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet"
  }
}

# ----- Internet Gateway -----
resource "aws_internet_gateway" "hotel_gw" {
  vpc_id = aws_vpc.hotel_vpc.id
  tags = {
    Name = "hotel-igw"
  }
}

# ----- Route Table -----
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.hotel_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.hotel_gw.id
  }

  tags = {
    Name = "public-rt"
  }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

# ----- Security Group -----
resource "aws_security_group" "hotel_sg" {
  name        = "hotel-sg"
  description = "Allow HTTP and SSH"
  vpc_id      = aws_vpc.hotel_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "hotel-sg"
  }
}

# ----- EC2 Instance -----
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical (Ubuntu)

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}
resource "aws_instance" "hotel_ec2" {
  ami                    = data.aws_ami.ubuntu.id # Ubuntu 22.04 LTS (Mumbai)
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public_subnet.id
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.hotel_sg.id]

  tags = {
    Name = "hotel-ec2"
  }
}

# ----- ECR Repository -----
resource "aws_ecr_repository" "hotel_ecr" {
  name = "hotel-management-repo"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "hotel-ecr"
  }
}
