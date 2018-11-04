## Simple EC2 PUBLIC

This exercise involves creating a simple EC2 Instance running ubuntu on a public subnet.
For this exercise you will need to 

- Create a RSA key pair using "ssh-keygen -t rsa" and save it in this folder as terraform_ec2_key
- Create a VPC
- Create a gateway
- Create a route table in the VPC, with a route to the internet via the new gateway

- Create a subnet

Each subnet in your VPC must be associated with a route table; the table controls the routing for the subnet. A subnet can only be associated with one route table at a time, but you can associate multiple subnets with the same route table.



- Associate the subnet to the new route table
- Create a EC2 instance using the latest ubuntu image
- Create a key pair
- Create an elastic IP
- Create a security group
- Assign the key pair, security group and elastic up to the EC2 Instance so that it can be accessed via ssh using a public ip
- ssh -i terraform_ec2_key ubuntu@public-elastic-ip.com



