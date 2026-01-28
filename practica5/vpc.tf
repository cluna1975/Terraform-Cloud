resource "aws_vpc" "vpc_virginia" {
  cidr_block = var.virginia_cidr
  tags = {
    Name = "VPC_Virginia "
    name = "prueba"
    env  = "dev"
  }
}

resource "aws_vpc" "vpc_ohio" {
  cidr_block = var.ohio_cidr
  tags = {
    Name = "VPC_ohio "
    name = "prueba"
    env  = "dev"
  }
  provider = aws.ohio
}

variable "virginia_cidr" {
  default     = "10.10.0.0/16"
  description = "CIDR de la VPC Virginia"
  type        = string
  sensitive   = true
}

variable "ohio_cidr" {
  default     = "10.20.0.0/16"
  description = "CIDR de la VPC Ohio"
  type        = string
  sensitive   = true
}
