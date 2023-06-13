provider "aws" {
  region  = "eu-central-1"
}

# SSH
variable "key_name" {}

resource "tls_private_key" "molecule_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Generate key_name and public key which will be uploaded on EC2 instance
resource "aws_key_pair" "generated_key" {
  key_name   = var.key_name
  public_key = tls_private_key.molecule_key.public_key_openssh

# Store private key :  Generate and save private key locally in current directory
  provisioner "local-exec" {
    command = <<-EOT
      echo '${tls_private_key.molecule_key.private_key_pem}' > ${var.key_name}.pem
      chmod 400 ${var.key_name}.pem
    EOT
  }
}

# Security groups
resource "aws_security_group" "allow_https_ssh_jenkins" {
  name        = "allow_https_ssh_jenkins"
  description = "Allow inbound traffic for defined ports"


ingress {
  description = "https"
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  }

ingress {
    description = "ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

ingress {
    description = "jenkins"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

egress {
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

tags = {
  Name = "allow_https_ssh_jenkins"
  }
}

# EC2 instances
variable "instance_type" {}
resource "aws_instance" "molecule_host" {
  ami           = "ami-04e601abe3e1a910f"
  instance_type = var.instance_type
  key_name      = aws_key_pair.generated_key.key_name
  security_groups=["${aws_security_group.allow_https_ssh_jenkins.name}"]

  connection {
        type    = "ssh"
        user    = "ubuntu"
        host    = aws_instance.molecule_host.public_ip
        port    = 22
        private_key = tls_private_key.molecule_key.private_key_pem
    }
   provisioner "remote-exec" {
        inline  = [
        "sudo apt-add-repository -y ppa:ansible/ansible",
        "sudo apt update",
        "sudo apt --assume-yes install ansible git",
        "sudo useradd -m ansible",
        "ssh-keygen -t rsa -N '' -f id_rsa",
        "sudo mkdir /etc/ansible/keys && sudo mkdir /home/ansible/.ssh",
        "sudo chown ansible:ansible id_rsa* && sudo chmod 400 id_rsa",
        "sudo mv id_rsa /etc/ansible/keys/ansible.private.key && sudo mv id_rsa.pub /home/ansible/.ssh",
        "echo 'ansible ALL=(ALL) NOPASSWD: ALL' | sudo tee -a /etc/sudoers.d/ansible",
        "git clone 'https://github.com/pidumenk/molecule-cicd.git'"        
       ]
    }

  tags = {
    Name = "molecule-instance"
  }
}

# EBS Volumes
resource "aws_ebs_volume" "molecule_volume" {
  size                = 25
  type                = "gp2"
  availability_zone   = aws_instance.molecule_host.availability_zone
  
  tags = {
    Name = "molecule-ebs-volume"
  }
}
