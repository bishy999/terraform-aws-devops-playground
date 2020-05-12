resource "aws_launch_configuration" "webapp" {
  name            = "${var.name}-ASG-launch-config"
  image_id        = var.ami
  instance_type   = var.instance_type
  security_groups = [aws_security_group.webserver_sg.id]
  key_name        = var.key_name

  lifecycle {
    create_before_destroy = true
  }
  user_data = file("${path.module}/user_data.sh")
}