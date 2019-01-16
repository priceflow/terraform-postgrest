output "id" {
  description = "The ARN of the certificate"
  value       = "${aws_acm_certificate.default.id}"
}

output "arn" {
  description = "The ARN of the certificate"
  value       = "${aws_acm_certificate.default.arn}"
}

output "domain_validation_options" {
  description = "CNAME records that are added to the DNS zone to complete certificate validation"
  value       = "${aws_acm_certificate.default.domain_validation_options}"
}
