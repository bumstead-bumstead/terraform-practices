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