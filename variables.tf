variable "public_key" {
  type      = string
  sensitive = true
}

variable "app_s3_bucket" {
  default = "app_s3_bucket"
  type    = string
}

variable "private_domain_name" {
  default = "example.com"
  type    = string
}
