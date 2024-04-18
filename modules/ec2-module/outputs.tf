output "ec2-public-ip" {
  value = aws_instance.demo-terraform-ec2.public_ip
}

output "ec2-ami" {
  value = aws_instance.demo-terraform-ec2.ami
}

output "ec2-type" {
  value = aws_instance.demo-terraform-ec2.instance_type
}

output "ec2-key" {
  value = aws_instance.demo-terraform-ec2.key_name
}

output "security-group-id" {
  value = aws_instance.demo-terraform-ec2.security_groups
}

output "subnet-id" {
  value = aws_instance.demo-terraform-ec2.subnet_id
}