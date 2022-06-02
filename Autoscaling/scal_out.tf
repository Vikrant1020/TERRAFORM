# resource "aws_autoscaling_policy" "example" {
#   autoscaling_group_name = aws_autoscaling_group.auto_scaling.name
#   name                   = "scale_out"
#   policy_type            = "PredictiveScaling"
#   cooldown               = 100
 
#   predictive_scaling_configuration {
#     metric_specification {
#       target_value = 10
      
#       predefined_load_metric_specification {
#         predefined_metric_type = "ASGTotalCPUUtilization"
#         resource_label         = "testLabel"
        
#       }
      
      
#       customized_scaling_metric_specification {
#         metric_data_queries {
#           id = "scaling"
#           metric_stat {
#             metric {
#               metric_name = ""
#               namespace   = "AWS/EC2"
#               dimensions {
#                 name  = "AutoScalingGroupName"
#                 value = "my-test-asg"
#               }
#             }
#             stat = "Average"
#           }
#         }
#       }
      
#     }
#   }
# }


