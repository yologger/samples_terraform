locals {
    vpc_name = "eks_vpc"
    default_route_table_name = "default_route_table"
}

# VPC 생성
resource "aws_vpc" "eks_vpc" {
  cidr_block = var.cidr_block
  tags = {
    Name = local.vpc_name
  }
}

# VPC 생성 시 같이 생성되는 Default VPC에 이름 추가
resource "aws_default_route_table" "default_route_table" {
    default_route_table_id = aws_vpc.eks_vpc.default_route_table_id
    tags = { 
      Name = local.default_route_table_name 
    }
}