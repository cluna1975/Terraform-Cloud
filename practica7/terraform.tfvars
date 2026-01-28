region        = "us-east-1"
virginia_cidr = "10.10.0.0/16"
#public_subnet  = ["10.10.0.0/24"]#
#private_subnet = ["10.10.1.0/24"]#
subnets = ["10.10.0.0/24", "10.10.1.0/24"]

tags = {
  "env"         = "dev"
  "owner"       = "CLUNA"
  "cloud"       = "AWS"
  "IAC"         = "Terraform"
  "iac_version" = "1.3.6"
  "project"     = "LUNERUS"
}

sg_ingress_cidr = "0.0.0.0/0"

ec2_specs = {
  "ami"           = "ami-0c02fb55956c7d316" # Amazon Linux 2023 Free Tier
  "instance_type" = "t2.micro"              # Free Tier eligible

}


