variable "aws_region" {
  description = "EC2 Region for the VPC"
  default     = "us-west-2"
}

variable "vpc_cidr" {
  description = "CIDR for the whole VPC"
  default     = "172.16.0.0/16"
}
