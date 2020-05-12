resource "aws_security_group" "webserver_sg" {
  vpc_id = var.vpc_id
  tags = merge(
    {
      "Name" = format("%s%s", var.name, "SG")
    },
    var.tags,
  )
}

resource "aws_security_group_rule" "allow_https" {
  type              = "ingress"
  security_group_id = aws_security_group.webserver_sg.id
  from_port         = var.https_port
  to_port           = var.https_port
  protocol          = var.protocol
  cidr_blocks       = [var.whitelist_myip]
}

resource "aws_security_group_rule" "allow_ssh" {
  type              = "ingress"
  security_group_id = aws_security_group.webserver_sg.id
  from_port         = var.ssh_port
  to_port           = var.ssh_port
  protocol          = var.protocol
  cidr_blocks       = [var.whitelist_myip]
}

resource "aws_security_group_rule" "allow_outgoing" {
  type              = "egress"
  security_group_id = aws_security_group.webserver_sg.id
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow_mycidr" {
  type              = "ingress"
  security_group_id = aws_security_group.webserver_sg.id
  from_port         = "0"
  to_port           = "65535"
  protocol          = var.protocol
  cidr_blocks       = [var.whitelist_mycidr]
}