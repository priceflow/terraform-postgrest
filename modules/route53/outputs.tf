output "id" {
  description = "The ARN of the certificate"
  value       = "${aws_acm_certificate.default.id}"
}

output "arn" {
  description = "The ARN of the certificate"
  value       = "${aws_acm_certificate_validation.default.certificate_arn}"
}

output "domain_validation_options" {
  description = "CNAME records that are added to the DNS zone to complete certificate validation"
  value       = "${aws_acm_certificate.default.domain_validation_options}"
}

output "hosted_zone_id" {
  description = "The hosted zone created"
  value       = "${aws_route53_zone.default.*.id}"
}
