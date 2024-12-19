# EC2 Instance resource
resource "aws_instance" "web" {
  ami           = "ami-036841078a4b68e14"  # Replace with a valid AMI ID for your region
  instance_type = "t2.micro"
  key_name      = "lsf-ovia-keys"           # Replace with your EC2 key pair name
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  subnet_id     = "subnet-0c85bcc6017adc15e"  # Replace with a valid subnet ID
  tags = {
    Name = "Terraform Web Server"
  }

   # Use remote-exec provisioner to install Apache after EC2 is created
  provisioner "remote-exec" {
    inline = [
      "sudo apt update -y",            # Update packages
      "sudo apt install -y apache2",     # Install Apache
      "sudo systemctl start apache2",    # Start Apache service
      "sudo systemctl enable apache2",   # Enable Apache to start on boot
      "echo 'Hello, Terraform!' | sudo tee /var/www/html/index.html"  # Create a basic webpage
    ]

    # SSH connection details for the EC2 instance
    connection {
      type        = "ssh"
      user        = "ubuntu"           # EC2 username (depends on the AMI)
      private_key = file("/home/ojpascale/lsf-ovia-keys.pem")  # Path to your private key
      host        = aws_instance.web.public_ip  # Use the public IP of the instance
    }
  }


}

  