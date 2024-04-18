provider "aws" {
  region = "us-east-1"  
}

variable "ec2-type" {
  description = "value"
  type = map(string)
  default = {
    "stage" = "t2.micro"
    "prod" = "t3.micro"
  }
}

variable "ec2-ami" {
  description = "value"
}

variable "ec2-key" {
  description = "value"
}

variable "security-group-id" {
  description = "value"
}

variable "subnet-id" {
  description = "value"
}

module "ec2-module" {
  source = "../modules/ec2-module"
  #ec2-type = var.ec2-type
  ec2-type = lookup(var.ec2-type, terraform.workspace, "t2.micro")
  ec2-ami = var.ec2-ami
  ec2-key = var.ec2-key
  security-group-id = [var.security-group-id]
  subnet-id = var.subnet-id
}