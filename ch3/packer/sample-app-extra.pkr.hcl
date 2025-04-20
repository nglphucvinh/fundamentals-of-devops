packer {
  required_plugins {
    amazon = {
      version = ">= 1.3.1"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

data "amazon-ami" "amazon-linux" {
  filters = {
    name = "al2023-ami-2023.*-x86_64"
  }
  owners      = ["amazon"]
  most_recent = true
  region      = "ap-southeast-2"
}

// Define a variable for the version number
variable "version" {
  type        = string
  description = "Version number to include in the AMI name"
  default     = "0.1.0"  // Default version if none is specified
}

source "amazon-ebs" "amazon-linux" {
  ami_name        = "sample-app-packer-v${var.version}-${uuidv4()}"
  ami_description = "Amazon Linux AMI with a Node.js sample app v${var.version}."
  instance_type   = "t2.micro"
  region          = "ap-southeast-2"
  source_ami      = data.amazon-ami.amazon-linux.id
  ssh_username    = "ec2-user"

  tags = {
    Name        = "Sample App AMI"
    Version     = var.version
    Environment = "production"
    BuildDate   = "{{ isotime }}"
  }
}

build {
  sources = ["source.amazon-ebs.amazon-linux"]

  provisioner "file" {
    sources     = ["sample-app"] 
    destination = "/tmp/"
  }

  provisioner "shell" {
    script       = "install-node.sh"
    pause_before = "30s"
  }
}