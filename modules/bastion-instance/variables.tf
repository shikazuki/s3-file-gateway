variable "name" {
  type = string
  default = "bastion"
  description = "Name prefix applied to all resource names."
}

variable "vpc_id" {
  type = string
  description = "VPC Id of the network."
}

variable "subnet_id" {
  type = string
  description = "Subnet Id of the bastion host."
}