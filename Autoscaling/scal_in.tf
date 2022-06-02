resource "aws_autoscalingplans_scaling_plan" "example" {
  name = "Metrix"

  application_source {
    tag_filter {
      key    = "Name"
      values = ["auto"]
    }
  }

  scaling_instruction {
   
    max_capacity       = 3
    min_capacity       = 2
    resource_id        = format("autoScalingGroup/%s", aws_autoscaling_group.auto_scaling.name )
    scalable_dimension = "autoscaling:autoScalingGroup:DesiredCapacity"
    service_namespace  = "autoscaling"
    

    target_tracking_configuration {
      predefined_scaling_metric_specification {
        predefined_scaling_metric_type = "ASGAverageCPUUtilization"
      }

      target_value = 10
      estimated_instance_warmup = 10
    }

  }
}