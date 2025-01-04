variable "name" {
  type = string
  description = "Name prefix applied to all resource names."
}

variable "vpc_id" {
  type = string
  description = "VPC Id of the network."
}

variable "vpc_cidr" {
  type = string
  description = "cidr blocks of the VPC."
}

variable "subnet_id" {
  type = string
  description = "Subnet Id of the storage gateway host."
}

variable "ami" {
  type = string
  description = "AMI of the storage gateway"
}

variable "instance_type" {
  type = string
  description = "Instance type for the gateway. The minimum is m4.xlarge instance."
}

variable "root_volume_size" {
  type = number
  description = "Root volume size in GB. The minimum is 80 GB."
}
