## Create a VPC
resource "aws_vpc" "my_vpc_002" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_hostnames = true

  tags {
    Name = "my_vpc_002"
  }
}

## Create a internet gateway for the VPC
resource "aws_internet_gateway" "my_gw_002" {
  vpc_id = "${aws_vpc.my_vpc_002.id}"

  tags {
    Name = "my_gw_002"
  }
}

## Creating public subnet
## Create a route table with a route to the internet (gw)
resource "aws_route_table" "my_vpc_002_public_rt" {
  vpc_id = "${aws_vpc.my_vpc_002.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.my_gw_002.id}"
  }

  tags {
    Name = "My VPC Public Route Table"
  }
}

## Create a public subnet in the VPC
resource "aws_subnet" "my_public_subnet_002" {
  vpc_id     = "${aws_vpc.my_vpc_002.id}"
  cidr_block = "${cidrsubnet(aws_vpc.my_vpc_002.cidr_block, 8, 1)}"

  tags {
    Name = "my_public_subnet_002"
  }
}

## Associate the route table with the subnet 
resource "aws_route_table_association" "my_vpc_002_rta" {
  subnet_id      = "${aws_subnet.my_public_subnet_002.id}"
  route_table_id = "${aws_route_table.my_vpc_002_public_rt.id}"
}

## Create the NAT instance in the public subnet
resource "aws_eip" "nat" {
  vpc = true
}

resource "aws_nat_gateway" "gw" {
  allocation_id = "${aws_eip.nat.id}"
  subnet_id     = "${aws_subnet.my_public_subnet_002.id}"
  depends_on    = ["aws_internet_gateway.my_gw_002"]

  tags {
    Name = "gw NAT"
  }
}

## Creating private subnet
## Create a subnet in the VPC
resource "aws_subnet" "my_private_subnet_002" {
  vpc_id     = "${aws_vpc.my_vpc_002.id}"
  cidr_block = "${cidrsubnet(aws_vpc.my_vpc_002.cidr_block, 8, 2)}"

  tags {
    Name = "my_private_subnet_002"
  }
}

## Create a route table with a route to the NAT
resource "aws_route_table" "my_vpc_002_private_rt" {
  vpc_id = "${aws_vpc.my_vpc_002.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_nat_gateway.gw.id}"
  }

  tags {
    Name = "My VPC Private Route Table"
  }
}

## Associate the route table with the subnet 
resource "aws_route_table_association" "my_vpc_002_private_rta" {
  subnet_id      = "${aws_subnet.my_private_subnet_002.id}"
  route_table_id = "${aws_route_table.my_vpc_002_private_rt.id}"
}
