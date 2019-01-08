resource "aws_launch_configuration" "default" {
  lifecycle {
    create_before_destroy = true
  }

  image_id       = "${var.ami}"
  instance_type  = "${var.instance_type}"
  key_name       = "${var.key_name}"
  security_group = ["${var.security_group}"]
}

resource "aws_autoscaling_group" "default" {
  lifecycle {
    create_before_destroy = true
  }

  name                 = "someapp - ${aws_launch_configuration.someapp.name}"
  launch_configuration = "${aws_launch_configuration.someapp.name}"
  desired_capacity     = "${var.nodes}"
  min_size             = "${var.nodes}"
  max_size             = "${var.nodes}"
  min_elb_capacity     = "${var.nodes}"
  availability_zones   = ["${split(",", var.azs)}"]
  vpc_zone_identifier  = ["${split(",", var.subnet_ids)}"]
  load_balancers       = ["${aws_elb.someapp.id}"]
}
