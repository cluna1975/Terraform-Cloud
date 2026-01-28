
variable "region" {
  type        = string
  description = "AWS Region to deploy resources"
  default     = "us-east-1"
}

variable "tags" {
  description = "Tags to apply to all resources by default"
  type        = map(string)
  default     = {}
}

