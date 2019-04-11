resource "aws_elasticache_cluster" "my-redis" {
  cluster_id           = "cluster-example"
  engine               = "redis"
  node_type            = "cache.t2.micro"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis3.2"
  engine_version       = "3.2.10"
  port                 = 6379
  subnet_group_name    = "${aws_elasticache_subnet_group.my-redis-subnet.name}"
  security_group_ids   = ["${aws_security_group.redis-sg.id}"]
}


resource "aws_security_group" "redis-sg" {
  
  vpc_id = "${aws_vpc.my_vpc.id}"
  name   = "redis-sg"

  ingress {
    from_port       = "6379"              # Redis
    to_port         = "6379"
    protocol        = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_elasticache_subnet_group" "my-redis-subnet" {
  name       = "tf-test-cache-subnet"
  subnet_ids = ["${aws_subnet.my_private_subnet_001.id}"],

}