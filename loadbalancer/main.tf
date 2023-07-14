
# Creating 2 load balancers for public and private 
resource "aws_lb" "sprints_lb" {
  count = 2
  name               = var.lb_attributes[count.index]["name"]
  internal           = var.lb_attributes[count.index]["internal"]
  load_balancer_type = "application"
  security_groups    = [var.security_group_id]
  subnets            = var.list_public_private_subnets_ids[count.index]

  tags = {
    Environment = "test_${count.index}"
  } 
}

# Creating 2 target group for public and private and attach them 
resource "aws_lb_target_group" "sprints_lbg" {
  count = 2
  name     = "tf-tg-sprints-${var.lb_attributes[count.index]["name"]}"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_ids
}

resource "aws_lb_target_group_attachment" "sprints_public_ga" {
  count = length(var.list_public_private_subnets_ids[0])
  target_group_arn = aws_lb_target_group.sprints_lbg[0].arn
  target_id        = var.public_instances[count.index]
  port             = 80
}

resource "aws_lb_target_group_attachment" "sprints_private_ga" {
  count = length(var.list_public_private_subnets_ids[1])
  target_group_arn = aws_lb_target_group.sprints_lbg[1].arn
  target_id        = var.private_instances[count.index]
  port             = 80
}


# Add target group listener to load balancer 
resource "aws_lb_listener" "example" {
  count = length(aws_lb.sprints_lb)
  load_balancer_arn = aws_lb.sprints_lb[count.index].id
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.sprints_lbg[count.index].id
    type             = "forward"
  }
}
