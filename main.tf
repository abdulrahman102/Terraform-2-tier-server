# Installing the proiveders plugins
provider "aws" {
    region = "us-east-1"
}
  
#_________INSERTING VPC MODULE__________

module "vpc_sprints" {
  source = "./vpc"
  public_subnets_attributes = var.public_subnets_attributes
  private_subnets_attributes = var.private_subnets_attributes
  vpc_cidr_block = var.vpc_cidr_block
}


#_________INSERTING EC2 INSTANCES MODULE__________

module "instances_sprints" {
  source = "./ec2"
  public_subnet_ids = module.vpc_sprints.public_subnets_id
  private_subnet_ids = module.vpc_sprints.private_subnets_id
  instances_number = 1
  vpc_ids = module.vpc_sprints.vpc_id
  lb_ip = module.lb_sprints.private_load_balanced_dns
}
 
#_________INSERTING LOAD BALANCER MODULE__________

module "lb_sprints" {
  source = "./loadbalancer"
  lb_attributes = var.lb_attributes
  security_group_id = module.instances_sprints.security_group_id
  list_public_private_subnets_ids = [module.vpc_sprints.public_subnets_id,module.vpc_sprints.private_subnets_id]
  vpc_ids = module.vpc_sprints.vpc_id
  public_instances = module.instances_sprints.public_instances_id
  private_instances = module.instances_sprints.private_instances_id
}


output "public_lb_ip" {
    value = module.lb_sprints.public_load_balancer_dns
}