resource "aws_s3_bucket" "mybucket" {
    bucket = "yohwan-example-bucket"

#   subnet_id = aws_subnet.example_subnet.id

    tags = {
        Name = "mybucket"
        Environment = "test"
    }
}

resource "aws_s3_bucket_policy" "public_access_policy" {
  bucket = aws_s3_bucket.mybucket.id
  policy = jsonencode({
    Id = "testBucketPolicy"
    Statement = [
      {
        Action = "s3:GetObject"
        Effect = "Allow"
        Principal = "*"
        Resource = [
          aws_s3_bucket.mybucket.arn,
          "${aws_s3_bucket.mybucket.arn}/*",
        ]
        Sid      = "statement1"
      }
    ]
    Version = "2012-10-17"
  })
}


resource "aws_s3_access_point" "vpc_access_point" {
  bucket = aws_s3_bucket.mybucket.id
  name   = "yohwan-vpc-access-point"

  vpc_configuration {
    vpc_id = aws_vpc.main.id
  }
}