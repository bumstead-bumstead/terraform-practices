
/*
required_providers 설정 -> 사용하는 resource들을 공급할 주체를 설정한다.
기본적으로 terraform registry에서 가져온당.
*/
terraform {
  required_providers {
    aws = {
      //optional hostname, a namespace, and the provider type 지정
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "app_server" {
  ami           = "ami-830c94e3"
  instance_type = "t2.micro"

  tags = {
    Name = "ExampleAppServerInstance"
  }
}