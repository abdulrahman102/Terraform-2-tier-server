# Assign local variable to use in the code
locals {
  outside_cidr_block = "0.0.0.0/0"
}

 
# Creating security group to allow http and ssh
resource "aws_default_security_group" "sprints_sg" {
  vpc_id      = var.vpc_ids

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [local.outside_cidr_block]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [local.outside_cidr_block]
  }


  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [local.outside_cidr_block]
  }


  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = [local.outside_cidr_block]
  }
  tags = {
    Name = "Sprints_sg"
  }
}



# Getting AMI data
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical 
}

output "name" {
  value = data.aws_ami.ubuntu.id
}


# Creating the public instances with provided information
resource "aws_instance" "public" {
  count = length(var.public_subnet_ids) * var.instances_number
  ami = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  associate_public_ip_address = true
  subnet_id = var.public_subnet_ids[count.index / var.instances_number]
  vpc_security_group_ids = [aws_default_security_group.sprints_sg.id]
    user_data = <<EOF
#! /bin/bash
sudo apt-get update
sudo apt-get install -y nginx
sudo systemctl start nginx
sudo systemctl enable nginx
sudo cat > /etc/nginx/sites-enabled/default << EOL
server {
    listen 80 default_server;
    location / {
    proxy_pass http://${var.lb_ip};
    }
}

EOL
sudo systemctl restart nginx
EOF

 provisioner "local-exec" {
  when        = create
  on_failure  = continue
   command = "echo public-${count.index} = ${self.public_ip} >> all_ip.txt"
 }

}

# Creating the private instances with provided information

resource "aws_instance" "private" {
  count = length(var.private_subnet_ids) * var.instances_number
  ami = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  associate_public_ip_address = false
  subnet_id = var.private_subnet_ids[floor(count.index / var.instances_number)]
  vpc_security_group_ids = [aws_default_security_group.sprints_sg.id]
    user_data = <<EOF
#! /bin/bash
sudo apt-get update
sudo apt-get install -y apache2
sudo systemctl start apache2
sudo systemctl enable apache2
export LOCAL_IP=$(hostname -I)
sudo echo "<H1>welcome to the private page !! IP : $LOCAL_IP </H1>" > /var/www/html/index.html
systemctl restart apache2
EOF
 
 provisioner "local-exec" {
   command = "echo private-${count.index} = ${self.private_ip} >> all_ip.txt"
 }
}

