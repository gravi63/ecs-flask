variable "listner_port" {
  type = number
}

variable "tg_port" {
  type = number
}

variable "subnets" {
  type = list
}

variable "security_groups" {
  type = list
}

variable "vpc_id" {
  type = string
}