provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "nginx_server" {
  ami           = "ami-0f918f7e67a3323f0"  # ubuntu
  instance_type = "t2.micro"

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install nginx -y
              sudo systemctl start nginx
              sudo systemctl enable nginx
              EOF

  

  vpc_security_group_ids = [aws_security_group.allow_traffic.id]  
}

resource "aws_security_group" "allow_traffic" {
  name        = "allow_ssh_http"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
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

output "public_ip" {
  value = aws_instance.nginx_server.public_ip
}
