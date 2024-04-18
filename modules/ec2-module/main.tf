provider "aws" {
  region = "us-east-1"  
}

resource "aws_instance" "demo-terraform-ec2" {
  ami = var.ec2-ami
  instance_type = var.ec2-type
  key_name = var.ec2-key
  security_groups = var.security-group-id
  subnet_id = var.subnet-id

  connection {
    type        = "ssh"
    user        = "ubuntu"  # Replace with the appropriate username for your EC2 instance
    private_key = file("../../terraform-key.pem")  # Replace with the path to your private key
    host        = self.public_ip # Or resource.demo-terraform-ec2.public_ip
    }

  provisioner "file" {
    source      = "../Deploy-app(provisioner)/app.py"  # Replace with the path to your local file
    destination = "/home/ubuntu/app.py"  # Replace with the path on the remote instance
    }

  provisioner "remote-exec" {
    inline = [
      "echo 'Hello from the remote instance'",
      # Update package lists (for ubuntu)
      "sudo apt-get install -y python3-pip",  # Example package installation
      "cd /home/ubuntu",
      "sudo pip3 install flask",
      "sudo python3 app.py &",
    ]
  }
}
