resource "aws_lb_target_group" "TG" {
  health_check {
    interval = 10
    path = "/"
    protocol = "HTTP"
    timeout = 5
    healthy_threshold = 5
    unhealthy_threshold = 2
  }
  name     = "TG"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "vpc-09340939ef20759dd"
}