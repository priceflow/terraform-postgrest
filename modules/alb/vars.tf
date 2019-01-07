variable "namespace" {
  description = "Namespace, which could be your organization name, e.g. `cp` or `cloudposse`"
  type        = "string"
}

variable "stage" {
  description = "Stage, e.g. `prod`, `staging`, `dev`, or `test`"
  type        = "string"
}

variable "delimiter" {
  description = "Delimiter to be used between `namespace`, `name`, `stage` and `attributes`"
  type        = "string"
  default     = "-"
}

variable "attributes" {
  description = "Additional attributes, e.g. `1`"
  type        = "list"
  default     = []
}

variable "name" {
  description = "Name to be used on all the resources as identifier"
  type        = "string"
  default     = ""
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = "map"

  default = {
    Name = ""
  }
}

variable "security_group_ids" {
  description = "A list of additional security group IDs to allow access to ALB"
  type        = "list"
  default     = []
}

variable "vpc_id" {
  description = "VPC ID to associate with ALB"
  type        = "string"
}

variable "subnet_ids" {
  description = "A list of subnet IDs to associate with ALB"
  type        = "list"
}

variable "internal" {
  description = "A boolean flag to determine whether the ALB should be internal"
  type        = "string"
  default     = "false"
}

variable "http_port" {
  description = "The port for the HTTP listener"
  type        = "string"
  default     = "80"
}

variable "http_enabled" {
  description = "A boolean flag to enable/disable HTTP listener"
  type        = "string"
  default     = "true"
}

variable "http_ingress_cidr_blocks" {
  description = "List of CIDR blocks to allow in HTTP security group"
  type        = "list"
  default     = ["0.0.0.0/0"]
}

variable "http_ingress_prefix_list_ids" {
  description = "List of prefix list IDs for allowing access to HTTP ingress security group"
  type        = "list"
  default     = []
}

variable "certificate_arn" {
  description = "The ARN of the default SSL certificate for HTTPS listener"
  type        = "string"
  default     = ""
}

variable "https_port" {
  description = "The port for the HTTPS listener"
  type        = "string"
  default     = "443"
}

variable "https_enabled" {
  description = "A boolean flag to enable/disable HTTPS listener"
  type        = "string"
  default     = "true"
}

variable "https_ingress_cidr_blocks" {
  description = "List of CIDR blocks to allow in HTTPS security group"
  type        = "list"
  default     = ["0.0.0.0/0"]
}

variable "https_ingress_prefix_list_ids" {
  description = "List of prefix list IDs for allowing access to HTTPS ingress security group"
  type        = "list"
  default     = []
}

variable "access_logs_prefix" {
  description = "The S3 bucket prefix"
  type        = "string"
  default     = ""
}

variable "access_logs_enabled" {
  description = "A boolean flag to enable/disable access_logs"
  type        = "string"
  default     = "true"
}

variable "access_logs_region" {
  description = "The region for the access_logs S3 bucket"
  type        = "string"
  default     = "us-west-2"
}

variable "cross_zone_load_balancing_enabled" {
  description = "A boolean flag to enable/disable cross zone load balancing"
  type        = "string"
  default     = "true"
}

variable "http2_enabled" {
  description = "A boolean flag to enable/disable HTTP/2"
  type        = "string"
  default     = "true"
}

variable "idle_timeout" {
  description = "The time in seconds that the connection is allowed to be idle"
  type        = "string"
  default     = "60"
}

variable "ip_address_type" {
  description = "The type of IP addresses used by the subnets for your load balancer. The possible values are `ipv4` and `dualstack`."
  type        = "string"
  default     = "ipv4"
}

variable "deletion_protection_enabled" {
  description = "A boolean flag to enable/disable deletion protection for ALB"
  type        = "string"
  default     = "false"
}

variable "deregistration_delay" {
  description = "The amount of time to wait in seconds before changing the state of a deregistering target to unused"
  type        = "string"
  default     = "15"
}

variable "health_check_path" {
  description = "The destination for the health check request"
  type        = "string"
  default     = "/"
}

variable "health_check_timeout" {
  description = "The amount of time to wait in seconds before failing a health check request"
  type        = "string"
  default     = "10"
}

variable "health_check_healthy_threshold" {
  description = "The number of consecutive health checks successes required before considering an unhealthy target healthy"
  type        = "string"
  default     = "2"
}

variable "health_check_unhealthy_threshold" {
  description = "The number of consecutive health check failures required before considering the target unhealthy"
  type        = "string"
  default     = "2"
}

variable "health_check_interval" {
  description = "The duration in seconds in between health checks"
  type        = "string"
  default     = "15"
}

variable "health_check_matcher" {
  description = "The HTTP response codes to indicate a healthy check"
  type        = "string"
  default     = "200-399"
}
