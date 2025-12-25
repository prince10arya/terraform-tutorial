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

resource "aws_instance" "example" {
    ami = "ami-0dee22c13ea7a9a67" // Ubuntu Server 24.04 LTS (HVM) - Free Tier eligible
    instance_type = "t3.micro"
    vpc_security_group_ids = [ "${aws_security_group.instance.id}" ]

    user_data = <<-EOF
                #!/bin/bash
                echo "Hello, World to AWS from Terraform" > index.html
                nohup busybox httpd -f -p 8080 &
                EOF

    tags = {
        name = "Terraform-Example"
    }
}

resource "aws_security_group" "instance" {
  name = "terraform-example-instance"

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

