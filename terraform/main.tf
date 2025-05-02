locals {
  vpc_id = "vpc-00625155b8c03e99c"
  ssh_user = "ec2-user"
  key_name = "DevOps"
  private_key_path = "./DevOps.pem"
  existing_security_group_id = "sg-0c464bdf396e675fa"
}


provider "aws" {
  region = "eu-central-1"
}

resource "aws_instance" "web" {
  ami             = "ami-0d8d11821a1c1678b"
  instance_type   = "t2.micro"
  associate_public_ip_address = true
  vpc_security_group_ids      = [local.existing_security_group_id]
  key_name = local.key_name

  tags = {
    Name = "DevOps-Instance"
  }

  provisioner "remote-exec" {
    inline = [
    "sudo yum install -y nc || sudo apt-get install -y netcat",
    "while ! nc -z localhost 22; do sleep 5; done"
    ]

    connection {
      type = "ssh"
      user = local.ssh_user
      host = self.public_ip
      private_key = file(local.private_key_path)
    }
  }
}


output "instance_id" {
  value = aws_instance.web.id
}

output "instance_public_ip" {
  value = aws_instance.web.public_ip
}