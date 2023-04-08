
resource "aws_instance" "myec2" {
  ami                    = "ami-0822295a729d2a28e"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.http_server_sg.id]

  tags = {
    Name = "myec2"
  }
}

