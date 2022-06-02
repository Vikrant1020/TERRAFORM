resource "aws_autoscaling_group" "auto_scaling" {
  name                      = "auto"
  max_size                  = 3
  min_size                  = 2
  health_check_grace_period = 10
  health_check_type         = "ELB"
  desired_capacity          = 2
  force_delete              = true
  launch_configuration      = aws_launch_configuration.LC.name
  vpc_zone_identifier       = ["subnet-01580a07e705fca59", "subnet-0c4cd5c2267d4935d", "subnet-03addf4d2461926fa"]

  tag {
    key                 = "Name"
    value               = "AUTO"
    propagate_at_launch = true
  }

  timeouts {
    delete = "10s"
  }

  tag {
    key                 = "Name"
    value               = "AUTO"
    propagate_at_launch = false
  }
}


resource "aws_launch_configuration" "LC" {
  name_prefix   = "LC"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  associate_public_ip_address = true
  lifecycle {
    create_before_destroy = true
  }
  user_data     = <<-EOF
                    #!/bin/bash
                    sudo apt update 
                    sudo apt install nginx -y
                    sudo systemctl start nginx
                    EOF

}

# resource "aws_autoscaling_attachment" "asg_attachment_bar" {
#   autoscaling_group_name = aws_autoscaling_group.auto_scaling.id
#   lb_target_group_arn   = aws_lb_target_group.alb_target_group.arn
# }