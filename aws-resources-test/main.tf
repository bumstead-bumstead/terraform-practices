terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "ap-northeast-1"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "Main"
  }
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "Public-subnet"
  }
}
resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "Private-subnet"
  }
}

resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Main"
  }
}

resource "aws_security_group" "http_server_sg" {
  name_prefix = "http-server-sg"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "http-server-sg"
  }
}

resource "aws_instance" "myec2" {
  ami                    = "ami-0822295a729d2a28e"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.http_server_sg.id]

  tags = {
    Name = "myec2"
  }
}

resource "aws_s3_bucket" "mybucket" {
    bucket = "yohwan-example-bucket"

#   subnet_id = aws_subnet.example_subnet.id

    tags = {
        Name = "mybucket"
        Environment = "test"
    }
}

resource "aws_s3_access_point" "vpc_access_point" {
  bucket = aws_s3_bucket.mybucket.id
  name   = "yohwan-vpc-access-point"

  vpc_configuration {
    vpc_id = aws_vpc.main.id
  }
}