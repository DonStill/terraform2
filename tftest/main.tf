// data blocks for vpc and subnets
data "aws_vpc" "default" {
  default = true
}

data "aws_subnet" "def_subnet_1" {
  id = "subnet-007e21fa02107bc0c"
}

data "aws_subnet" "def_subnet_2" {
  id = "subnet-00d7903b1489a067b"
}

// sg for alb and webservers
resource "aws_security_group" "alb_sg" {
  name        = "alb_sg"
  description = "sg for alb and webservers"
  vpc_id      = data.aws_vpc.default.id
  ingress {
    description = "inbound rules for alb"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "inbound rules for alb"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "inbound rules for alb"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "outbound rules for alb"
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

// alb configuration
resource "aws_alb" "alb_1" {
  internal           = false
  load_balancer_type = "application"
  name               = "alb-tf-1"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [data.aws_subnet.def_subnet_1.id, data.aws_subnet.def_subnet_2.id]
  depends_on         = [aws_security_group.alb_sg]
}

resource "aws_alb_target_group" "alb_tg_1" {
  load_balancing_algorithm_type = "round_robin"
  name                          = "alb-tg-1"
  port                          = 80
  protocol                      = "HTTP"
  slow_start                    = 120
  target_type                   = "instance"
  vpc_id                        = data.aws_vpc.default.id
  depends_on                    = [aws_alb.alb_1]
}

resource "aws_alb_listener" "alb_listener_1" {
  load_balancer_arn = aws_alb.alb_1.arn
  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.alb_tg_1.arn
  }
  port       = 80
  protocol   = "HTTP"
  depends_on = [aws_alb.alb_1, aws_alb_target_group.alb_tg_1]
}

// launch temp
resource "aws_launch_template" "lt_tf_1" {
  image_id             = "ami-02bf8ce06a8ed6092"
  instance_type        = "t2.micro"
  name                 = "wb-tf-1"
  vpc_security_group_ids = [ aws_security_group.alb_sg.id ]
  depends_on           = [aws_security_group.alb_sg]
  user_data = base64encode(
    <<-EOF
    #!/bin/bash
    sudo yum install httpd* -y
    sudo systemctl start httpd
    sudo systemctl enable httpd
    echo "Hi, I am $HOSTNAME" >> /var/www/html/index.html
    EOF
  )
}

//asg config
resource "aws_autoscaling_group" "asg-1" {
  name             = "asg-1"
  max_size         = 3
  min_size         = 1
  desired_capacity = 2
  launch_template {
    id      = aws_launch_template.lt_tf_1.id
    version = aws_launch_template.lt_tf_1.latest_version
  }
  health_check_type   = "ELB"
  vpc_zone_identifier = [data.aws_subnet.def_subnet_1.id, data.aws_subnet.def_subnet_2.id]
  target_group_arns   = [aws_alb_target_group.alb_tg_1.arn]
  depends_on          = [aws_launch_template.lt_tf_1, aws_alb_target_group.alb_tg_1]
}