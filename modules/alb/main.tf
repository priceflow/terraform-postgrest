resource "aws_security_group" "default" {
  description = "Controls access to the ALB (HTTP/HTTPS)"
  vpc_id      = "${var.vpc_id}"
  name        = "${var.name}"
  tags        = "${var.tags}"
}

resource "aws_security_group_rule" "egress" {
  type              = "egress"
  from_port         = "0"
  to_port           = "0"
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.default.id}"
}

resource "aws_security_group_rule" "http_ingress" {
  count             = "${var.http_enabled == "true" ? 1 : 0}"
  type              = "ingress"
  from_port         = "${var.http_port}"
  to_port           = "${var.http_port}"
  protocol          = "tcp"
  cidr_blocks       = ["${var.http_ingress_cidr_blocks}"]
  prefix_list_ids   = ["${var.http_ingress_prefix_list_ids}"]
  security_group_id = "${aws_security_group.default.id}"
}

resource "aws_security_group_rule" "https_ingress" {
  count             = "${var.https_enabled == "true" ? 1 : 0}"
  type              = "ingress"
  from_port         = "${var.https_port}"
  to_port           = "${var.https_port}"
  protocol          = "tcp"
  cidr_blocks       = ["${var.https_ingress_cidr_blocks}"]
  prefix_list_ids   = ["${var.https_ingress_prefix_list_ids}"]
  security_group_id = "${aws_security_group.default.id}"
}

resource "aws_lb" "default" {
  name                             = "${var.name}"
  tags                             = "${var.tags}"
  internal                         = "${var.internal}"
  load_balancer_type               = "application"
  security_groups                  = ["${compact(concat(var.security_group_ids, list(aws_security_group.default.id)))}"]
  subnets                          = ["${var.subnet_ids}"]
  enable_cross_zone_load_balancing = "${var.cross_zone_load_balancing_enabled}"
  enable_http2                     = "${var.http2_enabled}"
  idle_timeout                     = "${var.idle_timeout}"
  ip_address_type                  = "${var.ip_address_type}"
  enable_deletion_protection       = "${var.deletion_protection_enabled}"
}

resource "aws_lb_target_group" "default" {
  name                 = "${var.name}"
  port                 = "8080"
  protocol             = "HTTP"
  vpc_id               = "${var.vpc_id}"
  target_type          = "instance"
  deregistration_delay = "${var.deregistration_delay}"

  health_check {
    path                = "/rest/"
    timeout             = "${var.health_check_timeout}"
    healthy_threshold   = "${var.health_check_healthy_threshold}"
    unhealthy_threshold = "${var.health_check_unhealthy_threshold}"
    interval            = "${var.health_check_interval}"
    matcher             = "${var.health_check_matcher}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener" "http" {
  count             = "${var.https_enabled == "true" ? 1 : 0}"
  load_balancer_arn = "${aws_lb.default.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener" "https" {
  count             = "${var.https_enabled == "true" ? 1 : 0}"
  load_balancer_arn = "${aws_lb.default.arn}"

  port            = "${var.https_port}"
  protocol        = "HTTPS"
  ssl_policy      = "ELBSecurityPolicy-2016-08"
  certificate_arn = "${var.certificate_arn}"

  default_action {
    target_group_arn = "${aws_lb_target_group.default.arn}"
    type             = "forward"
  }

  lifecycle {
    create_before_destroy = true
  }
}
