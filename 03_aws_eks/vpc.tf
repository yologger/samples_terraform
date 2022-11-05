locals {
    vpc_name = "eks_vpc"
    default_route_table_name = "default_route_table"
    default_security_group = "default_security_group"
}

# VPC 생성
resource "aws_vpc" "eks_vpc" {
  cidr_block = var.cidr_block
  tags = {
    Name = local.vpc_name
  }
}

# VPC 생성 시 함께 생성되는 Route Table에 이름 추가
resource "aws_default_route_table" "default_route_table" {
    default_route_table_id = aws_vpc.eks_vpc.default_route_table_id
    tags = { 
      Name = local.default_route_table_name 
    }
}
## VPC 생성 시 함께 생성되는 Securiy Group에 이름 추가
resource "aws_default_security_group" "default_security_group" {
  vpc_id = aws_vpc.eks_vpc.id
  tags   = {
    Name = local.default_security_group
  }
}