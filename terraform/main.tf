provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "devops_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "devops-vpc"
  }
}

resource "aws_instance" "devops_instance" {
  ami           = "ami-0360c520857e3138f"
  instance_type = var.instance_type
 

  user_data = file("${path.module}/node_exporter.sh")

  tags = {
    Name = "DevOps-EC2"
  }
}

resource "aws_security_group" "devops_sg" {
  name        = "devops_sg"
  description = "Allow SSH and HTTP, Grafana, and Prometheus"
  // vpc-id - it will use default VPC

  // Allow SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  // Allow HTTP
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  // Allow Grafana
  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  // Allow Prometheus
  ingress {
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  // Allow Node Exporter metrics from local monitoring VM
  ingress {
    from_port   = 9100
    to_port     = 9100
    protocol    = "tcp"
    cidr_blocks = ["192.168.33.10/32"] # Replace with your Vagrant VM's private IP
    description = "Allow Node Exporter traffic from Prometheus VM"
  }

  // Allow all outbound traffic except port 22
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_s3_bucket" "devops_bucket" {
  bucket = var.bucket_name

  tags = {
    Name = "DevOpsBucket"
  }
}

// make separate s3 to store terraform state configration of current machine.
terraform {
  backend "s3" {
    bucket = "ayush-devops-demo-bucket" # Replace with your S3 bucket name
    key    = "terraform.tfstate"
    region = "us-east-1"
    encrypt = true
  }
}

