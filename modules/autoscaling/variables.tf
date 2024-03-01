variable "subnets" {
  type = list
}

variable "security_groups" {
  type = list
}

variable "image_id" {
  type = string
}

variable "ec2_key_name" {
  type = string
}

variable "iam_instance_profile" {
  type = string
}