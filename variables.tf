variable "vpc_cidr_block" {}

variable "lb_attributes" {}


variable "public_subnets_attributes"{
    type = list(object({
        cidr = string
        id = string
        az = string
    }))
}

variable "private_subnets_attributes"{
    type = list(object({
        cidr = string
        id = string
        az = string
    }))
} 