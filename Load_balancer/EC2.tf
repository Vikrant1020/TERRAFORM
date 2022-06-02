resource "aws_instance" "Host1" {
    ami           = "ami-0750a20e9959e44ff"
    instance_type = "t2.micro" 
    #key_name   = "terraform"
    associate_public_ip_address = true
    subnet_id = aws_subnet.subnet-2.id
    vpc_security_group_ids = [aws_security_group.allow.id]
    tags = {
    Name = "apache"
  }
  user_data = <<-EOF
                #!/bin/bash
                sudo apt update -y
                sudo apt install apache2 -y
                sudo systemctl start apache2
                sudo bash -c 'echo your very first web server apache > /var/www/html/index.html'
              EOF
}

resource "aws_instance" "Host2" {
    ami           = "ami-0750a20e9959e44ff"
    instance_type = "t2.micro" 
    #key_name   = "terraform"
    associate_public_ip_address = true
    subnet_id = aws_subnet.subnet-1.id
    vpc_security_group_ids = [aws_security_group.allow.id]
    tags = {
    Name = "nginx"
  }
  user_data = <<-EOF
                #!/bin/bash
                sudo apt update -y
                sudo apt install nginx -y
                sudo systemctl start nginx
              EOF
}