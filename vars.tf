variable "remote_bucket" {
  description = "s3 bucket for remote state"
  type        = "string"
  default     = "priceflow-staging-terraform-state"
}

variable "s3_path" {
  description = "s3 path for .env file"
  type        = "string"
  default     = ""
}

variable "name" {
  description = "Name to be used on all the resources as identifier"
  type        = "string"
  default     = ""
}

variable "ssh_user" {
  description = "Default SSH user for this AMI. e.g. `ec2user` for Amazon Linux and `ubuntu` for Ubuntu systems"
  type        = "string"
  default     = ""
}

variable "key_name" {
  description = "Key name"
  type        = "string"
  default     = ""
}

variable "instance_type" {
  description = "Ec2 instance type"
  type        = "string"
  default     = ""
}

variable "ami" {
  description = "AMI to use"
  type        = "string"
  default     = ""
}

variable "allowed_cidr_blocks" {
  description = "A list of CIDR blocks allowed to connect"
  type        = "list"

  default = [
    "0.0.0.0/0",
  ]
}

variable "hosted_zone_id" {
  description = "ID of the hosted zone to contain this record"
  default     = ""
}

variable "domain_name" {
  description = "Name of postgrest top domain"
  default     = ""
}

variable "num_instances" {
  description = "Number of postgrest instances to create"
  type        = "string"
  default     = "1"
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = "map"

  default = {
    Name = ""
  }
}
