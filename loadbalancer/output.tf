output "private_load_balanced_dns" {
    value = aws_lb.sprints_lb[1].dns_name
}

output "public_load_balancer_dns" {
  value = aws_lb.sprints_lb[0].dns_name
} 