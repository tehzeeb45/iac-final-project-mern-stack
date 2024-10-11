provider "aws" {
  region     = "us-east-1"
  access_key = "XXXXX"      
  secret_key = "XXXXXX"  
}

# Security Groups
resource "aws_security_group" "First_security_group" { # ya (First_security_group)  reference karne ke liye hota hai (jaise kisi EC2 instance ke saath jorna).
  name = "Test1SecurityGroup"
  
#####  Ingress Rules
###    These rules control incoming traffic to your instances:

  # Allow HTTP on port 80
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] ###   means that traffic from any IP address can access this port.
  }

  # Allow SSH on port 22
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow Jenkins on port 8080
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  # Allow custom container port (e.g., for an application running on 4440)
  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


##  Egress Rule
##   This rule controls outgoing traffic from your instances:


  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  ## -1 means All protocol 
    cidr_blocks = ["0.0.0.0/0"] 
  }
}

# AWS Instance
resource "aws_instance" "First_instance" {
  ami                         = "ami-0e86e20dae9224db8" # Ubuntu
  instance_type               = "t2.medium"
  key_name                    = "XXXXXXXX"
  vpc_security_group_ids      = [aws_security_group.First_security_group.id]
  user_data = file("${path.module}/user-data.sh")

 

  tags = {
    Name = "instance_from_terraform"
  }
}

# Output the public IP of the created instance
output "instance_public_ip" {
  value = aws_instance.First_instance.public_ip
}
