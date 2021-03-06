# Run specific user data when instances start up
data "template_file" "user_data" {
  template = "${file("${path.module}/user_data.sh")}"
  vars = {
    webapp_version = var.webapp_version
    dockerhub_repo = var.dockerhub_repo
  }
}

resource "aws_launch_configuration" "webapp" {
  name            = "${var.name}-ASG-launch-config"
  image_id        = var.ami
  instance_type   = var.instance_type
  security_groups = [aws_security_group.webserver_sg.id]
  key_name        = var.key_name

  lifecycle {
    create_before_destroy = true
  }
  user_data = data.template_file.user_data.rendered
}