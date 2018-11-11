## Create EC2 instance using the ubuntu image
resource "aws_instance" "private_server_002" {
  ami                    = "${data.aws_ami.ubuntu.id}"
  instance_type          = "t2.micro"
  subnet_id              = "${aws_subnet.my_private_subnet_002.id}"
  vpc_security_group_ids = ["${aws_security_group.db.id}"]
  key_name               = "${aws_key_pair.my_keypair_002.key_name}"

  tags {
    Name = "private_server_002"
  }
}

## Create a security group
resource "aws_security_group" "private_server_sg_002" {
  name        = "vpc_private_sg"
  description = "SG for private server"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = "${aws_vpc.my_vpc_002.id}"

  tags {
    Name = "private_server_sg"
  }
}
