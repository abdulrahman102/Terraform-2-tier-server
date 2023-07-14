# Assign local variable to use in the code
locals {
  outside_cidr_block = "0.0.0.0/0"
}


# Creating vpc
resource "aws_vpc" "sprints_vpc" {
  cidr_block = var.vpc_cidr_block
  
  tags = {
    Name = "sprints_vpc"
  }
}

# Creating num of subnets for public
resource "aws_subnet" "sprints_public_subnet" {
  count = length(var.public_subnets_attributes)
  vpc_id = aws_vpc.sprints_vpc.id
  cidr_block = var.public_subnets_attributes[count.index].cidr
  availability_zone_id = var.public_subnets_attributes[count.index].az
  tags = {
    Name = "sprints_${var.public_subnets_attributes[count.index].id}"
  }
  
} 

# Creating num of subnets for private 
resource "aws_subnet" "sprints_private_subnet" {
  count = length(var.private_subnets_attributes)
  vpc_id = aws_vpc.sprints_vpc.id
  cidr_block = var.private_subnets_attributes[count.index].cidr
  availability_zone_id = var.private_subnets_attributes[count.index].az
  tags = {
    Name = "sprints_${var.private_subnets_attributes[count.index].id}"
  }
  
} 


# Creating Internet gateway for public subnet to use
resource "aws_internet_gateway" "sprints_ig" {
  vpc_id = aws_vpc.sprints_vpc.id
  tags = {
    Name = "sprints_ig"
  }
}

# Getting Elastic ip and assign it to nat gateway for private subnet to use
resource "aws_eip" "sprints_eip" {}
resource "aws_nat_gateway" "sprints_ng" {
  allocation_id = aws_eip.sprints_eip.id
  subnet_id = aws_subnet.sprints_public_subnet[0].id
  
}

# Creating route table for public subnet
resource "aws_route_table" "sprints_rt_public" {
  vpc_id = aws_vpc.sprints_vpc.id

  route {
    cidr_block = local.outside_cidr_block
    gateway_id = aws_internet_gateway.sprints_ig.id
      }
  
}

# Creating route table for private subnet
resource "aws_route_table" "sprints_rt_private" {
  vpc_id = aws_vpc.sprints_vpc.id

  route  {
    cidr_block = local.outside_cidr_block
    nat_gateway_id = aws_nat_gateway.sprints_ng.id
  }

}

# Assigning the 2 route tables to the subnets
resource "aws_route_table_association" "sprints_rta_public" {
  count = length(aws_subnet.sprints_public_subnet)
  subnet_id = aws_subnet.sprints_public_subnet[count.index].id
  route_table_id = aws_route_table.sprints_rt_public.id
  
}

resource "aws_route_table_association" "sprints_rta_private" {
  count = length(aws_subnet.sprints_private_subnet)
  subnet_id = aws_subnet.sprints_private_subnet[count.index].id
  route_table_id = aws_route_table.sprints_rt_private.id
  
}

