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
  availability_zone = "ap-southeast-1a"
  tags = {
    "Name" = "Tarreform"
  }
}
resource "aws_subnet" "subnet-2" {
  vpc_id = aws_vpc.terraform.id
  cidr_block = "10.0.4.0/24"
  availability_zone = "ap-southeast-1b"
  tags = {
    "Name" = "Tarreform"
  }
}
resource "aws_subnet" "subnet-3" {
  vpc_id = aws_vpc.terraform.id
  cidr_block = "10.0.5.0/24"
  availability_zone = "ap-southeast-1c"
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
resource "aws_route_table_association" "A" {
  subnet_id      = aws_subnet.subnet-2.id
  route_table_id = aws_route_table.terraform.id
}

resource "aws_route_table_association" "B" {
  subnet_id      = aws_subnet.subnet-1.id
  route_table_id = aws_route_table.terraform.id
}

resource "aws_route_table_association" "C" {
  subnet_id      = aws_subnet.subnet-3.id
  route_table_id = aws_route_table.terraform.id
}