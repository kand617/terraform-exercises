## Create a VPC
resource "aws_vpc" "my_vpc_001" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_hostnames = true

  tags {
    Name = "my_vpc_001"
  }
}

## Create a internet gateway for the VPC
resource "aws_internet_gateway" "my_gw_001" {
  vpc_id = "${aws_vpc.my_vpc_001.id}"

  tags {
    Name = "my_gw_001"
  }
}

## Create a route table with a route to the internet (gw)
resource "aws_route_table" "my_vpc_001_rt" {
  vpc_id = "${aws_vpc.my_vpc_001.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.my_gw_001.id}"
  }

  tags {
    Name = "My VPC Public Route Table"
  }
}

## Create a subnet in the VPC
resource "aws_subnet" "my_public_subnet_001" {
  vpc_id     = "${aws_vpc.my_vpc_001.id}"
  cidr_block = "${cidrsubnet(aws_vpc.my_vpc_001.cidr_block, 8, 1)}"

  tags {
    Name = "my_public_subnet_001"
  }
}

## Associate the route table with the subnet 
resource "aws_route_table_association" "my_vpc_001_rta" {
  subnet_id      = "${aws_subnet.my_public_subnet_001.id}"
  route_table_id = "${aws_route_table.my_vpc_001_rt.id}"
}
