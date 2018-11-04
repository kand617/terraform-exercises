## Create a key pair
resource "aws_key_pair" "my_keypair_001" {
  key_name   = "my_keypair_001"
  public_key = "${file("terraform_ec2_key.pub")}"
}

## Create EC2 instance using the ubuntu image
resource "aws_instance" "web" {
  ami                         = "${data.aws_ami.ubuntu.id}"
  instance_type               = "t2.micro"
  subnet_id                   = "${aws_subnet.my_public_subnet_001.id}"
  vpc_security_group_ids      = ["${aws_security_group.web.id}"]
  key_name                    = "${aws_key_pair.my_keypair_001.key_name}"
  associate_public_ip_address = true
  source_dest_check           = false

  tags {
    Name = "my_server_001"
  }
}

## Create a security group
resource "aws_security_group" "web" {
  name        = "vpc_web"
  description = "Allow incoming HTTP connections."

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

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

  vpc_id = "${aws_vpc.my_vpc_001.id}"

  tags {
    Name = "WebServerSG"
  }
}

## Create an Elastic IP for the ec2 instance
resource "aws_eip" "web-1" {
  instance = "${aws_instance.web.id}"
  vpc      = true
}
