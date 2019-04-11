resource "aws_vpc" "my_vpc" {
  cidr_block = "172.17.0.0/16"
}


## Create a internet gateway for the VPC
resource "aws_internet_gateway" "my_gw" {
  vpc_id = "${aws_vpc.my_vpc.id}"

  tags {
    Name = "my_gw"
  }
}

## Creating public subnet

resource "aws_subnet" "my_public_subnet_002" {
  vpc_id     = "${aws_vpc.my_vpc.id}"
  cidr_block = "${cidrsubnet(aws_vpc.my_vpc.cidr_block, 8, 2)}"

  tags {
    Name = "my_public_subnet_002"
  }
}

## Create a route table with a route to the internet (gw)
resource "aws_route_table" "my_vpc_002_public_rt" {
  vpc_id = "${aws_vpc.my_vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.my_gw.id}"
  }

  tags {
    Name = "My VPC Public Route Table"
  }
}
## Associate the route table with the subnet 
resource "aws_route_table_association" "my_vpc_002_rta" {
  subnet_id      = "${aws_subnet.my_public_subnet_002.id}"
  route_table_id = "${aws_route_table.my_vpc_002_public_rt.id}"
}


## Create private subnet


resource "aws_subnet" "my_private_subnet_001" {
  vpc_id     = "${aws_vpc.my_vpc.id}"
  cidr_block = "${cidrsubnet(aws_vpc.my_vpc.cidr_block, 8, 1)}"

  tags {
    Name = "my_private_subnet_001"
  }
}


# Create a nat eip
resource "aws_eip" "nat" {
  vpc = true
}

#place the nat gateway on the public subnet
resource "aws_nat_gateway" "gw" {
  allocation_id = "${aws_eip.nat.id}"
  subnet_id     = "${aws_subnet.my_public_subnet_002.id}"
  depends_on    = ["aws_internet_gateway.my_gw"]

  tags {
    Name = "gw NAT"
  }
}


## Create a route table with a route to the NAT from the private subnet
resource "aws_route_table" "my_vpc_002_private_rt" {
  vpc_id = "${aws_vpc.my_vpc.id}"

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
  subnet_id      = "${aws_subnet.my_private_subnet_001.id}"
  route_table_id = "${aws_route_table.my_vpc_002_private_rt.id}"
}
