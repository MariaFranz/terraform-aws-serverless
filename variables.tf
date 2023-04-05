variable "location" {
  type        = string
  description = "The location of the resource. Defaults to North Europe"
  default     = "eu-north-1"
}

variable "function_name" {
  type    = string
  default = "tt"
}
