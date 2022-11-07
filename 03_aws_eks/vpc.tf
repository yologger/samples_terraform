locals {
    vpc_name = "eksVpc"
    vpc_cidr = "10.194.0.0/16"
    default_route_table_name = "eksVpc_default_routeTable"
    default_security_group_name = "eksVpc_default_securityGroup"
    public_subnets = ["10.194.0.0/24", "10.194.1.0/24"]  
    azs = ["ap-northeast-2a", "ap-northeast-2c"]
    cluster_name = "eksCluster"
}

# VPC 생성
resource "aws_vpc" "eks_vpc" {
  cidr_block = local.vpc_cidr
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
    Name = local.default_security_group_name
  }
}

## Public Subnet 정의
resource "aws_subnet" "public_subnets" {
  count = length(local.public_subnets)
  vpc_id = aws_vpc.eks_vpc.id
  cidr_block = local.public_subnets[count.index]
  availability_zone = local.azs[count.index]
  map_public_ip_on_launch = true  ## Public Subnet에 배치되는 서비스는 자동으로 Public IP를 할당받는다.
  tags = {
    Name = "${local.vpc_name}_publicSubnet_${count.index+1}",
    "kubernetes.io/cluster/${local.cluster_name}" = "shared",
    "kubernetes.io/role/elb" = "1"
  }
}

## Public Subnet에 연결할 Internet Gateway 정의
resource "aws_internet_gateway" "eks_internet_gateway" {
  vpc_id = aws_vpc.eks_vpc.id
  tags = {
    Name = "${local.vpc_name}_internetGateway"
  }
}

## Public Subnet과 Internet Gateway 연결을 위한 Route Table 정의
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.eks_vpc.id
  tags = { 
    Name = "${local.vpc_name}_public_routeTable"
  }
}

## Internet Gateway와 Route Table 연결
resource "aws_route" "internetGateway_routeTable_route" {
  route_table_id = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.eks_internet_gateway.id
}

## Public Subnet과 Route Table 연결
resource "aws_route_table_association" "publicSubnet_routeTable_association" {
  count = length(local.public_subnets)
  subnet_id = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}