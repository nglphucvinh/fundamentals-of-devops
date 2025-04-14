packer {
  required_plugins {
    amazon = {
      version = ">= 1.3.1"
      source  = "github.com/hashicorp/amazon"
    }
    azure = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/azure"
    }
    googlecompute = {
      version = ">= 1.1.4"
      source  = "github.com/hashicorp/googlecompute"
    }
    virtualbox = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/virtualbox"
    }
    docker = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/docker"
    }
  }
}

# AWS configuration
data "amazon-ami" "amazon-linux" {
  filters = {
    name = "al2023-ami-2023.*-x86_64"
  }
  owners      = ["amazon"]
  most_recent = true
  region      = "us-east-2"
}

source "amazon-ebs" "amazon-linux" {
  ami_name        = "sample-app-packer-${uuidv4()}"
  ami_description = "Amazon Linux AMI with a Node.js sample app."
  instance_type   = "t2.micro"
  region          = "us-east-2"
  source_ami      = data.amazon-ami.amazon-linux.id
  ssh_username    = "ec2-user"
}

# Azure configuration
source "azure-arm" "azure-linux" {
  os_type         = "Linux"
  image_publisher = "Canonical"
  image_offer     = "UbuntuServer"
  image_sku       = "18.04-LTS"
  image_version   = "latest"
  location        = "East US"
  vm_size         = "Standard_B1s"
  ssh_username    = "packer"
  managed_image_resource_group_name = "packer-images"
  managed_image_name = "sample-app-packer-${uuidv4()}"
}

# GCP configuration
source "googlecompute" "gcp-linux" {
  project_id   = "xxx"
  source_image = "ubuntu-1804-bionic-v20230307"
  zone         = "us-central1-a"
  ssh_username = "packer"
  machine_type = "f1-micro"
  image_name   = "sample-app-packer-${uuidv4()}"
  image_labels = {
    app = "sample-app"
  }
}

# VirtualBox configuration
source "virtualbox-iso" "virtualbox-linux" {
  iso_url          = "https://releases.ubuntu.com/18.04/ubuntu-18.04.6-live-server-amd64.iso"
  iso_checksum     = "sha256:f5cbb8104348f0097a8e513b10173a07dbc6684595e331cb06f93f385d0aecf6"
  guest_os_type    = "Ubuntu_64"
  ssh_username     = "packer"
  ssh_password     = "packer"
  ssh_timeout      = "30m"
  shutdown_command = "echo 'packer' | sudo -S shutdown -P now"
  disk_size        = 10000
  memory           = 1024
  headless         = true
}

# Docker configuration
source "docker" "docker-linux" {
  image  = "ubuntu:18.04"
  commit = true
}

build {
  sources = [
    "source.amazon-ebs.amazon-linux",
    "source.azure-arm.azure-linux",
    "source.googlecompute.gcp-linux",
    "source.virtualbox-iso.virtualbox-linux",
    "source.docker.docker-linux"
  ]

  provisioner "file" {
    source      = "app.js"
    destination = "/home/${build.User}/app.js"
  }

  provisioner "shell" {
    script       = "install-node.sh"
    pause_before = "30s"
  }
}