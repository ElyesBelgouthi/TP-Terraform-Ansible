provider "aws" {
  region = "eu-central-1"
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH traffic"

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  
  }

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web" {
  ami             = "ami-0d8d11821a1c1678b"
  instance_type   = "t2.micro"
  associate_public_ip_address = true
  security_groups = [aws_security_group.allow_ssh.name]
  key_name = "DevOps"

  tags = {
    Name = "DevOps-Instance"
  }

  provisioner "remote-exec" {
    inline = [
    "while ! nc -z localhost 22; do sleep 5; done"
    ]

    connection {
      type = "ssh"
      host = aws_instance.web.public_ip
    }
  }
}


output "instance_id" {
  value = aws_instance.web.id
}

output "instance_public_ip" {
  value = aws_instance.web.public_ip
}