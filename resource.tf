resource "aws_vpc" "terraform-main" {
  cidr_block  = "10.0.0.0/16"

  tags = {
    Name = "terraform"
  }
}

resource "aws_internet_gateway" "terraform-igw" {
  vpc_id = "${aws_vpc.terraform-main.id}"

  tags = {
    Name = "terraform"
  }
}

resource "aws_subnet" "terraform-main" {
  vpc_id     = "${aws_vpc.terraform-main.id}"
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "terraform"
  }
}

resource "aws_security_group" "abhinav-terraform" {
  name        = "abhinav-terraform"
  description = "abhinav-terraform"
  vpc_id      = "${aws_vpc.terraform-main.id}"

  ingress {
    from_port   = 0
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.0.1.0/24"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["10.0.1.0/24"]
  }
}

resource "aws_key_pair" "default" {
  key_name = "abhinav-terraform"
  public_key = "${file("${var.key_path}")}"
}

resource "aws_instance" "instance-terraform" {
  ami = "${var.ami}"
  instance_type = "${var.instance_type}"
  key_name = "${aws_key_pair.default.id}"
  vpc_security_group_ids = [ "${aws_security_group.abhinav-terraform.id}"]
  subnet_id = "${aws_subnet.terraform-main.id}"
  user_data = "${file("bootstrap-server1.sh")}"

  tags {
    Name = "instance-terraform"
  }
}

resource "aws_elb" "terraform" {
  name = "ec2-elb"
  instances = ["${aws_instance.instance-terraform.id}"]
  subnets = ["${aws_subnet.terraform-main.id}"]

  listener {
    instance_port = 80
    instance_protocol = "tcp"
    lb_port = 80
    lb_protocol = "tcp"
  }

  health_check {
    target = "HTTP:80/"
    healthy_threshold = 2
    unhealthy_threshold = 2
    interval = 30
    timeout = 5
  }

  tags {
    Name = "ec2-elb"
  }
}
