provider "aws" {
  region = "ap-south-1"  # Mumbai (your location)
}

resource "aws_vpc" "demo" {
  cidr_block = "10.0.0.0/16"
  tags = { Name = "terraform-demo-vpc" }
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.demo.id
  cidr_block = "10.0.1.0/24"
  tags       = { Name = "public-subnet" }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.demo.id
  tags   = { Name = "demo-igw" }
}

resource "aws_instance" "demo_ec2" {
  ami           = "ami-0c02fb55956c7d316"  # Ubuntu 22.04 ap-south-1 Free Tier
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.public.id

  tags = {
    Name = "Lambu-Vinay-Terraform-Demo"
  }

  user_data = <<-EOF
              #!/bin/bash
              apt update -y && apt install -y nginx
              systemctl start nginx
              EOF
}

output "ec2_public_ip" {
  value = aws_instance.demo_ec2.public_ip
}
