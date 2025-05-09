provider "aws" {                                               
  region = var.region
}

resource "aws_security_group" "sample_app" {                   
  name        = var.name
  description = "Allow HTTP traffic into ${var.name}"
}

resource "aws_security_group_rule" "allow_http_inbound" {      
  type              = "ingress"
  protocol          = "tcp"
  from_port         = var.instance_port
  to_port           = var.instance_port
  security_group_id = aws_security_group.sample_app.id
  cidr_blocks       = var.allowed_cidr_blocks
}

data "aws_ami" "sample_app" {                                  
  filter {
    name   = "name"
    values = [var.ami_name_pattern]
  }
  owners      = ["self"]
  most_recent = true
}

resource "aws_instance" "sample_app" {                         
  ami                    = data.aws_ami.sample_app.id
  instance_type          = var.type
  vpc_security_group_ids = [aws_security_group.sample_app.id]
  user_data              = file("${path.module}/user-data.sh")

  tags = {
    Name = var.name
    Test = "update"
  }

}