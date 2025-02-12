provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "vulnerable_bucket" {
  bucket = "vulnerable-public-bucket"
  acl    = "public-read"  # Insecure: Publicly accessible S3 bucket
}

resource "aws_security_group" "insecure_sg" {
  name        = "insecure_sg"
  description = "Allow all inbound traffic"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # Insecure: Allows all inbound traffic
  }
}

resource "aws_instance" "vulnerable_instance" {
  ami           = "ami-12345678"  # Example AMI ID, replace with actual
  instance_type = "t2.micro"
  key_name      = "hardcoded-key"  # Insecure: Hardcoded key

  user_data = <<-EOF
              #!/bin/bash
              echo "my_secret_password" > /etc/secret.txt  # Insecure: Hardcoded secret in user data
              EOF

  security_groups = [aws_security_group.insecure_sg.name]
}

output "instance_ip" {
  value = aws_instance.vulnerable_instance.public_ip  # Insecure: Public IP exposed
}