resource "aws_lb" "alb" {
  name               = "${var.name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.security_group_ids
  subnets            = var.public_subnet_ids

  tags = merge(var.common_tags, {
    Name = "${var.name}-alb"
  })
}

resource "aws_lb_target_group" "ecs" {
  name        = "${var.name}-ecs-tg"
  port        = 3000
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    enabled             = true
    path                = var.health_check_path
    port                = "3000"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 3
    matcher             = "200-399"
  }

  tags = merge(var.common_tags, {
    Name = "${var.name}-ecs-tg"
  })
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs.arn
  }

  tags = merge(var.common_tags, {
    Name = "${var.name}-https-listener"
  })
}

output "alb_id" {
  value = aws_lb.alb.id
}

output "alb_arn" {
  value = aws_lb.alb.arn
}

output "dns_name" {
  value = aws_lb.alb.dns_name
}

output "target_group_arn" {
  value = aws_lb_target_group.ecs.arn
}

output "zone_id" {
  value = aws_lb.alb.zone_id
}
