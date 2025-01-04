variable "name" {
  type        = string
  description = "Name prefix applied to all resource names."
}

variable "bucket_name" {
  type        = string
  description = "Name of the bucket to share."
}

variable "activation_key" {
  type        = string
  description = "The activation API key should be gotten from storage gateway server."
}
