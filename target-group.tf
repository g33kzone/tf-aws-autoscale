resource "aws_lb_target_group" "mrw_target_group" {
  name                          = "web-app-tg"
  port                          = 80
  protocol                      = "HTTP"
  vpc_id                        = aws_vpc.mrw_vpc.id
  target_type                   = "instance"
  load_balancing_algorithm_type = "least_outstanding_requests"

  health_check {
    enabled             = true
    healthy_threshold   = 5
    unhealthy_threshold = 2
    interval            = 10
    path                = "/orders"
    protocol            = "HTTP"
    timeout             = 5
    matcher             = "200-399"
  }
}