provider "aws" {
  region = "eu-central-1"
}

resource "aws_instance" "web" {
  ami           = "ami-0d8d11821a1c1678b"
  instance_type = "t2.micro"

  tags = {
    Name = "DevOps-Instance"
  }
}

output "instance_id" {
  value = aws_instance.web.id
}

output "instance_public_ip" {
  value = aws_instance.web.public_ip
}