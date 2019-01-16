variable "domain_name" {
  description = "A domain name for which the certificate should be issued"
  type        = "string"
}

variable "validation_method" {
  description = "Which method to use for validation, DNS or EMAIL"
  type        = "string"
  default     = "DNS"
}

variable "process_domain_validation_options" {
  type        = "string"
  default     = "true"
  description = "Flag to enable/disable processing of the record to add to the DNS zone to complete certificate validation"
}

variable "ttl" {
  description = "The TTL of the record to add to the DNS zone to complete certificate validation"
  type        = "string"
  default     = "300"
}

variable "tags" {
  description = "Additional tags (e.g. map('BusinessUnit`,`XYZ`)"
  type        = "map"
  default     = {}
}

variable "subject_alternative_names" {
  description = "A list of domains that should be SANs in the issued certificate"
  type        = "list"
  default     = []
}
