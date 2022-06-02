

resource "aws_lb" "test" {
  name               = "Terraform"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["sg-0012900144295c4fd"]
  subnets            = ["subnet-01580a07e705fca59", "subnet-0c4cd5c2267d4935d", "subnet-03addf4d2461926fa"]

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



