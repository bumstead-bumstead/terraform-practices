
resource "aws_instance" "myec2" {
  ami                    = "ami-0822295a729d2a28e"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.http_server_sg.id]
  key_name               = "MyKey"


  tags = {
    Name = "myec2"
  }
}

resource "aws_key_pair" "myKey" {
  key_name   = "MyKey"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCIkd0KdKkaA5pk6+s8MtkqQrdmKaSH0CyWqewh3aD0Ipyop8IuhVSJ9y3d9esIjHwHInwTTnKh0vrVAbO/bxZ8wvwEUqwXs01sGBMi2TZawZwEpJjwSGUV3UuQ4IJGdOm9Y3i4/BQBOolKVFOjZSohJ0A/Yx+/RxLD/Vm6J0bcWa81PHQGugBK22WZlmaRi5/wQ/xW0clggEHDLVc+xRboRuQc/zeDZoaKbeL61GFTEeLz0gma9v4YxyWe2XLvCkWqEsNEx1VXnFHGAzf7bgvCS3VoxQozCSEEKQkunkr+4gY3h8pSVeZZ0NE9iRvaks+JE+NDt8o9NRGXtGsA3WEp"
}