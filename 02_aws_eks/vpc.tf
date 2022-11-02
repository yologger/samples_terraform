resource "aws_vpc" "eks_vpc" {
  cidr_block = "10.110.0.0/16"
}