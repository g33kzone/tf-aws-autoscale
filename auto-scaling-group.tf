data "aws_ami" "amzn2-ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.2020*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  owners = ["amazon"]
}

resource "aws_launch_configuration" "mrw_web_launch_conf" {
  name                        = "mrw-web-app-launch-conf"
  image_id                    = data.aws_ami.amzn2-ami.id
  instance_type               = var.instance_type
  associate_public_ip_address = true
  key_name                    = "g33kzone-devops"
  security_groups             = [aws_security_group.allow_http.id]
  user_data                   = file("install_apache.sh")
  lifecycle {
    create_before_destroy = true
  }
}

data "aws_subnet" "subnet_values" {
  for_each = aws_subnet.mrw_public_subnet
  id       = each.value.id
  depends_on = [
    aws_subnet.mrw_public_subnet
  ]
}

resource "random_string" "random_asg" {
  length  = 8
  special = false
  upper   = false
  lower   = true
  number  = true
}

resource "aws_autoscaling_group" "mrw_web_asg_group" {
  name = "mrw-web-app-asg${random_string.random_asg.result}"

  min_size         = 1
  max_size         = 4
  desired_capacity = 2

  launch_configuration      = aws_launch_configuration.mrw_web_launch_conf.name
  health_check_type         = "ELB"
  health_check_grace_period = 300
  force_delete              = true
  vpc_zone_identifier       = [for s in data.aws_subnet.subnet_values : s.id]

  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances"
  ]

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [load_balancers, target_group_arns]
  }
}

resource "aws_autoscaling_policy" "web_app_policy_scale_out" {
  name                   = "web_app_scale_out_policy"
  autoscaling_group_name = aws_autoscaling_group.mrw_web_asg_group.id
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  scaling_adjustment     = 1
}

resource "aws_autoscaling_policy" "web_app_policy_scale_in" {
  name                   = "web_app_scale_in_policy"
  autoscaling_group_name = aws_autoscaling_group.mrw_web_asg_group.id
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  scaling_adjustment     = -1
}

resource "aws_autoscaling_attachment" "web_app_asg_tg" {
  autoscaling_group_name = aws_autoscaling_group.mrw_web_asg_group.id
  alb_target_group_arn   = aws_lb_target_group.mrw_target_group.arn
}

resource "aws_autoscaling_notification" "mrw_web_asg_group_notify" {
  group_names = [aws_autoscaling_group.mrw_web_asg_group.name]

  notifications = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
    "autoscaling:EC2_INSTANCE_TERMINATE_ERROR",
  ]

  topic_arn = aws_sns_topic.mrw_web_app_sns_topic.arn
}