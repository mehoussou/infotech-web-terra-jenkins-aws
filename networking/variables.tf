# --- networking/variables.tf ---

variable "vpc_cidr" {
  type = string
}

variable "public_cidrs" {
  type = list(any)
}

variable "vpc_cidr_block" {
  default = "10.0.0.0/16"
}

variable "subnet_cidr_block" {
  default = "10.0.0.0/24"
}

variable "vpc_cidr_block" {
  default = "us-east-2"
}


variable "env_prefix" {
  default = "dev"
}

variable "my_ip" {
  default = "75.71.114.225/32"
}

variable "instance_type" {
  default = "t2.micro"
}
