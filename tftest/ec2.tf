resource "aws_instance" "myinstance" {
  availability_zone = "us-east-2b"
  ami               = "ami-02bf8ce06a8ed6092"
  instance_type     = "t2.micro"
  tags = {
    "Name" = "mytestinstance"
  }
}