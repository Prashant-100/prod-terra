provider "aws" {
  region = "ap-south-1"
}
resource "aws_security_group" "sg" {
  vpc_id = "vpc-011acb9cc3dec505a"
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = -1
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = -1
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    "Name" = "terraform-sg"
  }
}
resource "aws_instance" "my_instance" {
  ami                    = "ami-068257025f72f470d"
  vpc_security_group_ids = [aws_security_group.sg.id]
  instance_type          = "t2.micro"
  key_name               = "ec2"
  tags = {
    "Name" = "terraform-ec2"
  }
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("./ec2.pem")
    host        = aws_instance.my_instance.public_ip
  }
  provisioner "file" {
    source      = "./get-docker.sh"
    destination = "/home/ubuntu/get-docker.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo sh /home/ubuntu/get-docker.sh",
      "sudo systemctl start docker"
    ]
  }
}
