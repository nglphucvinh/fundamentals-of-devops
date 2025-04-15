variable "name" {
  description = "The name for the EC2 instance and all resources."
  type        = string
  default     = "sample-app-tofu"
}

variable "type" {
  description = "The type of EC2 instance"
  type = string
  default = "t2-micro"
}

variable "region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "us-east-2"
}

variable "instance_port" {
  description = "Port to allow inbound traffic to the instance"
  type        = number
  default     = 8080
}

variable "allowed_cidr_blocks" {
  description = "List of CIDR blocks allowed to access the instance"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "ami_name_pattern" {
  description = "Name pattern for AMI lookup"
  type        = string
  default     = "sample-app-packer-*"
}