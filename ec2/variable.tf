

variable "instances_number" {
  description = "number of instance per subnet"
  type = number
}

variable "vpc_ids" {}

variable "lb_ip" {
  description = "private load balancer dns name which will refer in proxy servers"
  type = string
}


variable "public_subnet_ids" {
  type = list(string)
}

variable "private_subnet_ids" {
  type = list(string)
} 