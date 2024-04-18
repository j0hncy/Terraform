provider "aws" {
  region = "us-east-1"  # Replace with your desired AWS region.
}

variable "cidr" {
  default = "10.0.0.0/16"
}

resource "aws_vpc" "myvpc" {
  cidr_block = var.cidr
  tags = {
    Name = "myvpc"
  }  
  }

resource "aws_subnet" "sub1" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.myvpc.id
}

resource "aws_route_table" "RT" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "rta1" {
  subnet_id      = aws_subnet.sub1.id
  route_table_id = aws_route_table.RT.id
}

resource "aws_security_group" "webSg" {
  name   = "web"
  vpc_id = aws_vpc.myvpc.id

  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name = "Web-sg"
  }
}

module "ec2-module" {
  source = "../modules/ec2-module"
  ec2-type = "t2.micro"
  ec2-ami = "ami-080e1f13689e07408"
  ec2-key = "terraform-key"
  security-group-id = [aws_security_group.webSg.id]
  subnet-id = aws_subnet.sub1.id
}

resource "aws_instance" "example" {
  # Use attributes from the EC2 module
  ami = module.ec2-module.ec2-ami
  instance_type = module.ec2-module.ec2-type
  key_name = module.ec2-module.ec2-key
  security_groups = module.ec2-module.security-group-id
  subnet_id = module.ec2-module.subnet-id

}