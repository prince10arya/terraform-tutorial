terraform {
  required_providers {
    aws = {
        source  = "hashicorp/aws"
        version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

// input variable for server port
variable "server_port" {
  description = "the port for ther server will use for HTTP request"
  default = 8080
}

resource "aws_instance" "example" {
    ami = "ami-0dee22c13ea7a9a67" // Ubuntu Server 24.04 LTS (HVM) - Free Tier eligible
    instance_type = "t3.micro"
    vpc_security_group_ids = [ "${aws_security_group.instance.id}" ]

    user_data = <<-EOF
                #!/bin/bash
                echo "Hello, World to AWS from Terraform" > index.html
                nohup busybox httpd -f -p "${var.server_port}" &
                EOF

    tags = {
        name = "Terraform-Example"
    }
}

resource "aws_security_group" "instance" {
  name = "terraform-example-instance"

  ingress {
    from_port   = "${var.server_port}"
    to_port     = "${var.server_port}"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


// output the public IP address of the instance
output "instance_ip_addr" {
    description = "The public IP address of the web server instance"
    value       = aws_instance.example.public_ip
}

