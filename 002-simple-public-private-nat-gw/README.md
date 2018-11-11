## Utilise NAT to Access EC2 on a private subnet

This exercise involves creating a public and private subnet, with the aim of accessing a EC2 instance on the private subnet via a Internet Gateway + NAT Gateway implementation. 

## Building the VPC Network

- Two subnets (public, private)
- Two route tables
- One internet gateway
- One Nat Gateway


## Builing the public subnet

- One EC2 instance with Elastic IP
- One NAT Gateway with Elastic IP
- One Route Table assigned to the public subnet
  - Route Dest 0.0.0.0/0 to IGW
  - 172.16.0.0 to Local
    

## Building the private subnet

- One EC2 instance that has :
  - connectivity to public subnet EC2
  - connectivity to the internet through NAT GW
  - security group to allow icmp and ssh from public subnet
  - icmp from the private to the internet
- One Route Table assigned to the private subnet
  - Route Dest 0.0.0.0/0 to NAT GW
  - 172.16.0.0 to Local






