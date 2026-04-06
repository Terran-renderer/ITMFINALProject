provider "aws" {
  region = "us-east-1"
}
resource "aws_instance" "app" {
  ami           = "ami-0c02fb55956c7d316" # Amazon Linux
  instance_type = "t2.micro"

  key_name = "mykey"

  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  user_data = file("${path.module}/user_data.sh")

  tags = {
    Name = "terraform-app"
  }
}
resource "aws_security_group" "allow_ssh" {
  name = "allow_ssh"

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
output "ec2_ip" {
  value = aws_instance.app.public_ip
}
