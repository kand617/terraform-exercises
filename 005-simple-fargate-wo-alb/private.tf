resource "aws_key_pair" "my_keypair_002" {
  key_name   = "my_keypair_002"
  public_key = "${file("terraform_ec2_key.pub")}"
}

## Create EC2 instance using the ubuntu image
resource "aws_instance" "private_server_002" {
  ami                    = "${data.aws_ami.ubuntu.id}"
  instance_type          = "t2.micro"
  subnet_id              = "${aws_subnet.my_private_subnet_001.id}"
  vpc_security_group_ids = ["${aws_security_group.private_server_sg_002.id}"]
  key_name               = "${aws_key_pair.my_keypair_002.key_name}"

  tags {
    Name = "private_server_002"
  }
}


## Create a security group for private subnet
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

  egress {
    from_port   = 1
    to_port     = 10000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = "${aws_vpc.my_vpc.id}"

  tags {
    Name = "private_server_sg"
  }
}



resource "aws_instance" "public_server_001" {
  ami                    = "${data.aws_ami.ubuntu.id}"
  instance_type          = "t2.micro"
  subnet_id              = "${aws_subnet.my_public_subnet_002.id}"
  vpc_security_group_ids = ["${aws_security_group.public_server_sg_002.id}"]
  key_name               = "${aws_key_pair.my_keypair_002.key_name}"
  associate_public_ip_address = true

  tags {
    Name = "public_server_002"
  }
}


## Create a security group for public subnet
resource "aws_security_group" "public_server_sg_002" {
  name        = "vpc_public_sg"
  description = "SG for public server"

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
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  vpc_id = "${aws_vpc.my_vpc.id}"

  tags {
    Name = "public_server_sg"
  }
}

## Create an Elastic IP for the ec2 instance
resource "aws_eip" "web-1" {
  instance = "${aws_instance.public_server_001.id}"
  vpc      = true
}
