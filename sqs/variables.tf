variable "location" {
  type = string
  description = "The location of the resource. Defaults to North Europe"
  default = "eu-north-1"
}

variable "redrive_policy" {
  description = "The JSON policy to set up the Dead Letter Queue, see AWS docs. Note: when specifying maxReceiveCount, you must specify it as an integer (5), and not a string (\"5\")"
  type        = string
  default     = ""
}

variable "name" {
  default     = "terraform-example-queue"
}