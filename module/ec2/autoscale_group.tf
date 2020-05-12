
resource "aws_autoscaling_group" "asg" {
  name                 = "${var.name}-ASG"
  launch_configuration = aws_launch_configuration.webapp.name
  target_group_arns    = [aws_lb_target_group.alb_tg.arn]
  vpc_zone_identifier  = [for r in var.private_subnets : r]
  min_size             = 3
  max_size             = 10
  desired_capacity     = 3

  tag {
    key                 = "Name"
    value               = "${var.name}-ASG"
    propagate_at_launch = true
  }

}
