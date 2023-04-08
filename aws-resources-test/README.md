## 목표

terraform으로 VPC, EC2, S3, LB 설정하기

- VPC에 서브넷, 인터넷 게이트웨이 설정
- EC2에 VPC, 서브넷, sg 할당해서 생성
- S3에 access point로 VPC 설정해서 생성

## main.tf

```powershell
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
```

- VPC를 따로 만들어서 public/private 서브넷, 게이트웨이를 각각 설정했다.
- ec2에 보안 그룹과 서브넷을 할당시켰다.
- s3 버킷에 access point로 vpc를 지정했다.

## 주의할 점

- 리전이랑 ami → t2.micro 가용한 지 확인하기

## 궁금한 점

- VPC에 그냥 게이트웨이 사용하는 것과 NAT 사용하는 것의 차이는? private 서브넷을 인터넷에 연결할 수 있는 것? 이것의 장점은?
- 

## 다음 단계

- 리소스 모듈화
- 게이트웨이? LB? IP 거르는 설정
- s3 public/private 설정
- 콘솔에서 build하고 apply하면, 로컬의 aws cli configuration의 IAM을 바탕으로 만들어지는데, resource를 만드는 과정에서 이를 설정할 수 있는 방법
- API의 요청 형태에 맞춰서 tf 모듈 생성하고, 이를 apply하는 과정 구상