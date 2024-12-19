# Output the public IP for easy access
  output "web_instance_public_ip" {
    value = aws_instance.web.public_ip
  }
