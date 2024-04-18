output "ec2-public-ip" {
  value = aws_instance.demo-terraform-ec2.public_ip
}