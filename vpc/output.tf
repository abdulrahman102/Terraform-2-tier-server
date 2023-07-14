output "vpc_id" {
  value = aws_vpc.sprints_vpc.id
}

output "public_subnets_id" {
    value = aws_subnet.sprints_public_subnet[*].id
  
}

output "private_subnets_id" {
    value = aws_subnet.sprints_private_subnet[*].id

} 