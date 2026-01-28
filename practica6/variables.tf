
variable "region" {
  type        = string
  description = "AWS Region to deploy resources"
  default     = "us-east-1"
}

variable "virginia_cidr" {
  description = "CIDR block for the Virginia VPC"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources by default"
  type        = map(string)
  default     = {}
}


#variable "public_subnet" {
#type        = list(string)
#description = "Public Subnet CIDR Blocks"
#}

#variable "private_subnet" {
# type        = list(string)
#description = "Private Subnet CIDR Blocks"
#}
variable "subnets" {
  type        = list(string)
  description = "Subnet CIDR Blocks"
}

variable "sg_ingress_cidr" {
  type        = string
  description = "CIDR blocks for ingress rules"
}

variable "ec2_specs" {
  type        = map(string)
  description = "EC2 Parameters instance"

}
