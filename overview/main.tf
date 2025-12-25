terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
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
}

