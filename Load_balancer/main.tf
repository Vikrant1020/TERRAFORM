provider "aws" {
  profile = "default"
  region = "ap-southeast-1"
}


resource "aws_lb" "test" {
  name               = "Terraform"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow.id]
  subnets            = data.aws_subnets.ids.ids

  enable_deletion_protection = false

#   access_logs {
#     bucket  = aws_s3_bucket.lb_logs.bucket
#     prefix  = "test-lb"
#     enabled = true
#   }

  tags = {
    Name = "Terraform"
  }
}
resource "aws_lb_target_group_attachment" "apache" {
  target_group_arn = aws_lb_target_group.TG.arn
  target_id        = aws_instance.Host1.id
  port             = 80
}
resource "aws_lb_target_group_attachment" "nginx" {
  target_group_arn = aws_lb_target_group.TG.arn
  target_id        = aws_instance.Host2.id
  port             = 80
}


