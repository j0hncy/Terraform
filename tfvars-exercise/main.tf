provider "aws" {
  region = "us-east-1"  
}

resource "aws_instance" "demo-terraform-ec2" {
  ami = var.ec2-ami
  instance_type = var.ec2-type
}

