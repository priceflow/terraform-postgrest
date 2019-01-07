provider "aws" {
  region = "us-west-2"
}

terraform {
  backend "s3" {}
}

data "terraform_remote_state" "vpc" {
  backend = "s3"

  config {
    bucket = "${var.remote_bucket}"
    key    = "vpc/terraform.tfstate"
    region = "us-west-2"
  }
}

data "terraform_remote_state" "rds" {
  backend = "s3"

  config {
    bucket = "${var.remote_bucket}"
    key    = "rds/terraform.tfstate"
    region = "us-west-2"
  }
}

data "template_file" "user_data" {
  template = "${file("${path.module}/user_data.sh")}"

  vars {
    S3_PATH  = "${var.s3_path}"
    RDS_HOST = "${data.terraform_remote_state.rds.instance_address}"
  }
}

data "aws_iam_policy_document" "default" {
  statement {
    sid = ""

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    effect = "Allow"
  }
}

resource "aws_iam_instance_profile" "default" {
  name = "${var.name}"
  role = "${aws_iam_role.default.name}"
}

resource "aws_iam_role" "default" {
  name = "${var.name}"
  path = "/"

  assume_role_policy = "${data.aws_iam_policy_document.default.json}"
}

resource "aws_iam_role_policy_attachment" "rds" {
  role       = "${aws_iam_role.default.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonRDSFullAccess"
}

resource "aws_iam_role_policy_attachment" "s3" {
  role       = "${aws_iam_role.default.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role_policy_attachment" "secrets" {
  role       = "${aws_iam_role.default.name}"
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
}

resource "aws_security_group" "default" {
  name        = "${var.name}"
  vpc_id      = "${data.terraform_remote_state.vpc.vpc_id}"
  description = "Security group: open 22, 80, 8080, 443"

  ingress {
    protocol  = "tcp"
    from_port = 22
    to_port   = 22

    cidr_blocks = ["${var.allowed_cidr_blocks}"]
  }

  ingress {
    protocol  = "tcp"
    from_port = 80
    to_port   = 80

    cidr_blocks = ["${var.allowed_cidr_blocks}"]
  }

  ingress {
    protocol  = "tcp"
    from_port = 443
    to_port   = 443

    cidr_blocks = ["${var.allowed_cidr_blocks}"]
  }

  ingress {
    protocol  = "tcp"
    from_port = 8080
    to_port   = 8080

    cidr_blocks = ["${var.allowed_cidr_blocks}"]
  }

  ingress {
    protocol  = "tcp"
    from_port = 3000
    to_port   = 3000

    cidr_blocks = ["${var.allowed_cidr_blocks}"]
  }

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = -1
    security_groups = ["${data.terraform_remote_state.vpc.default_security_group_id}"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_instance" "default" {
  ami           = "${var.ami}"
  instance_type = "${var.instance_type}"
  count         = "${var.num_instances}"
  user_data     = "${data.template_file.user_data.rendered}"

  vpc_security_group_ids = [
    "${compact(concat(list(aws_security_group.default.id), list(data.terraform_remote_state.vpc.default_security_group_id)))}",
  ]

  iam_instance_profile        = "${aws_iam_instance_profile.default.name}"
  associate_public_ip_address = "true"
  key_name                    = "${var.key_name}"
  subnet_id                   = "${data.terraform_remote_state.vpc.public_subnets[0]}"
  tags                        = "${merge(map("Name", format("%s", var.name)), var.tags)}"
}

module "alb" {
  source    = "./modules/alb"
  namespace = "priceflow"
  name      = "postgrest"
  stage     = "${var.stage}"

  vpc_id             = "${data.terraform_remote_state.vpc.vpc_id}"
  subnet_ids         = ["${data.terraform_remote_state.vpc.public_subnets}"]
  certificate_arn    = "${module.acm_request_certificate.id}"
  ip_address_type    = "ipv4"
  access_logs_region = "us-west-2"
}

module "acm_request_certificate" {
  source                            = "./modules/route53"
  domain_name                       = "${var.domain_name}"
  process_domain_validation_options = "true"
  ttl                               = "300"
  subject_alternative_names         = ["*.${var.domain_name}"]
}

resource "aws_lb_target_group_attachment" "default" {
  count            = "${var.num_instances}"
  target_group_arn = "${module.alb.default_target_group_arn}"
  target_id        = "${element(aws_instance.default.*.private_ip, count.index)}"
  port             = 443

  lifecycle {
    ignore_changes = true
  }
}

resource "aws_route53_record" "www" {
  zone_id = "${var.hosted_zone_id}"
  name    = "postgrest.${var.domain_name}"
  type    = "A"
  ttl     = "300"
  records = ["${module.alb.alb_dns_name}"]
}

