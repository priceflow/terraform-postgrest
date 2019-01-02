variable "remote_bucket" {
  description = "s3 bucket for remote state"
  type        = "string"
  default     = "priceflow-staging-terraform-state"
}

variable "s3_path" {
  description = "s3 path for .env file"
  type        = "string"
  default     = "s3://priceflow-staging/postgrest/.env"
}

variable "name" {
  description = "Name to be used on all the resources as identifier"
  type        = "string"
  default     = "app-staging-postgrest"
}

variable "ssh_user" {
  description = "Default SSH user for this AMI. e.g. `ec2user` for Amazon Linux and `ubuntu` for Ubuntu systems"
  type        = "string"
  default     = "ubuntu"
}

variable "key_name" {
  description = "Key name"
  type        = "string"
  default     = "staging"
}

variable "instance_type" {
  description = "Ec2 instance type"
  type        = "string"
  default     = "t3.small"
}

variable "ami" {
  description = "AMI to use"
  type        = "string"
  default     = "ami-036f2557c8e4540aa"
}

variable "allowed_cidr_blocks" {
  description = "A list of CIDR blocks allowed to connect"
  type        = "list"

  default = [
    "0.0.0.0/0",
  ]
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = "map"

  default = {
    Name = "app-staging-postgrest"
  }
}
