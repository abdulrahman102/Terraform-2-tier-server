output "security_group_id" {
    value = aws_default_security_group.sprints_sg.id
}

output "public_instances_id" {
    value = aws_instance.public[*].id
  
}

output "private_instances_id" {
  value = aws_instance.private[*].id
}
