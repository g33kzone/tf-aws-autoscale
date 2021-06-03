resource "aws_lb" "web_app_alb" {
  name               = "web-app-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow_alb_http.id]
  subnets            = [for s in data.aws_subnet.subnet_values : s.id]
  ip_address_type    = "ipv4"

  # access_logs {
  #   bucket  = aws_s3_bucket.s3_elb_logs.bucket
  #   prefix  = "test-lb"
  #   enabled = true
  # }

  tags = {
    Name = "web-app-alb"
  }
}

resource "aws_lb_listener" "web_app_listener" {
  load_balancer_arn = aws_lb.web_app_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.mrw_target_group.arn
  }
}

resource "aws_lb_listener_rule" "web_app_listener_rule" {
  listener_arn = aws_lb_listener.web_app_listener.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.mrw_target_group.arn
  }
  condition {
    path_pattern {
      values = ["/orders"]
    }
  }
}