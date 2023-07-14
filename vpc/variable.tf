variable "vpc_cidr_block" {
    description = "cidr block of the vpc"
}



variable "public_subnets_attributes"{
    description = "a list of objects containg public subnet attribute for each subnet cidr block and name of subnet and availblty zone"
    type = list(object({
        cidr = string
        id = string
        az = string
    }))
}

variable "private_subnets_attributes"{
    description = "a list of objects containg private subnet attribute for each subnet cidr block and name of subnet and availblty zone"
    type = list(object({
        cidr = string
        id = string
        az = string
    }))
} 