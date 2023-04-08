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
