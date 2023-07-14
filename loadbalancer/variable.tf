variable "lb_attributes" {
  description = "a list of object (name of the lb and a boolean if it's internal or not) ordered like [{public_att},{private_att}]"
    type = list(object({
        name = string
        internal = bool
    }))
  
} 

variable "security_group_id" {}

variable "vpc_ids" {
  type = string
}

variable "public_instances" {
  description = "a list of public instances ids"

  
}


variable "private_instances" {
    description = "a list of private instances ids"

  
} 


variable "list_public_private_subnets_ids" {
    description = "a list of list of both public_subnet_ids and private_subnet_ids  ordered like [[public_ids],[private_ids]]"

  type=list(list(string))
}
 