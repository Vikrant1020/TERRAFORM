
# creating key for ec2
resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCm5i1iVTLE5cCaud/LS7pRogUwiARD7qgZ8FPi9e37iC8Z3q1kKZSIqNqk33KUnMIQ/K/dBHC1y9E/Hu7qtY+WTkemZq7wU7nQ8F7ZJp2wAe5+L0SJOdZJk3fFkAjdAvLHngX11bvQy8Pyv57JrSapWNpYWpCIsX3m7t9CYE/9LZVR7Rpjl1gh4AHUkOuEAUfrW7rxaKMH3MjNqi0SOM/xG1wvQSV0wXpbV7NimGebH3fxZ216MH14DMfA250qBoTS4xH3bjm5GcC9FrqnlhDvN/ouLUdTihKfNW6xYDXtMurKHQPAKnyIk2Qe3ZtTiEM//GMmVdSBjwlK0Uf+vYpZ"
}

# creating VPC
resource "aws_vpc" "terraform" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true
  enable_classiclink_dns_support = true

  enable_classiclink = true
  tags ={
    Name = "teraform"
  }
}

# creating subnet
resource "aws_subnet" "subnet-1" {
  vpc_id = aws_vpc.terraform.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "ap-northeast-1a"
  tags = {
    "Name" = "Tarreform"
  }
}
resource "aws_subnet" "subnet-2" {
  vpc_id = aws_vpc.terraform.id
  cidr_block = "10.0.4.0/24"
  availability_zone = "ap-northeast-1d"
  tags = {
    "Name" = "Tarreform"
  }
}
resource "aws_subnet" "subnet-3" {
  vpc_id = aws_vpc.terraform.id
  cidr_block = "10.0.5.0/24"
  availability_zone = "ap-northeast-1c"
  tags = {
    "Name" = "Tarreform"
  }
}

# creating internet gate way
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.terraform.id
  tags = {
    "Name" = "Terraform"
  }
}

# crating security group
resource "aws_security_group" "allow" {
  name        = "allow"
 # description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.terraform.id

  ingress {
    # description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    #ipv6_cidr_blocks = [vpc-0e058d6c1c81f6a27]
  }
  ingress {
    # description      = "TLS from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    #ipv6_cidr_blocks = [vpc-0e058d6c1c81f6a27]
  }
  ingress {
    # description      = "TLS from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    #ipv6_cidr_blocks = [vpc-0e058d6c1c81f6a27]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow"
  }
}


resource "aws_route_table" "terraform" {
  vpc_id = aws_vpc.terraform.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  route {
    ipv6_cidr_block        = "::/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "terraform"
  }
}
# 5. Associate subnet with Route Table
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.subnet-2.id
  route_table_id = aws_route_table.terraform.id
}

# resource "aws_network_interface" "ANI" {
#   subnet_id = aws_subnet.subnet-2.id
#   private_ips = ["10.0.4.50"]
#   security_groups = [aws_security_group.allow.id]
# }

# resource "aws_eip" "lb" {
#   instance = aws_instance.host.id
#   vpc      = true
# }


#creating EC2 instance
resource "aws_instance" "host" {
  ami           = "ami-0a3eb6ca097b78895"
  instance_type = "t2.micro"
  #count = 1
  key_name   = "terraform"
  associate_public_ip_address = true
  subnet_id = aws_subnet.subnet-2.id
  vpc_security_group_ids = [aws_security_group.allow.id]

  # network_interface {
  #   device_index = 0
  #   network_interface_id = aws_network_interface.ANI.id
  # }
  tags = {
    Name = "Tvk"
  }
  volume_tags = {
    "Name" = "terraform"
  }
  user_data = <<-EOF
                #!/bin/bash
                sudo apt update -y
                sudo apt install apache2 -y
                sudo systemctl start apache2
                sudo bash -c 'echo your very first web server > /var/www/html/index.html'
              EOF

}


# # fetching data for ecb by adding filters 
# data "aws_ebs_volume" "ebs_volume" {
#   most_recent = true

#   filter {
#     name   = "volume-type"
#     values = ["gp2"]
#   }

#   filter {
#     name   = "tag:Name"
#     values = ["terraform"]
#   }
# }

# # taking snapshort using data . 
# resource "aws_ebs_snapshot" "ss" {
#   volume_id = data.aws_ebs_volume.ebs_volume.id

#   tags = {
#     Name = "ss"
#   }
# }
