locals {
    vpc_name = "eks-vpc"
    vpc_cidr = "10.194.0.0/16"
    public_subnets = ["10.194.0.0/24", "10.194.1.0/24"]  
    private_subnets = ["10.194.100.0/24", "10.194.101.0/24"]
    azs = ["ap-northeast-2a", "ap-northeast-2c"]
    cluster_name = "eks-cluster"
}

# VPC 생성
resource "aws_vpc" "eks_vpc" {
  cidr_block = local.vpc_cidr
  tags = { Name = local.vpc_name }
}

# VPC와 함께 생성되는 Default Route Table에 이름 추가
resource "aws_default_route_table" "default_routetable" {
  default_route_table_id = aws_vpc.eks_vpc.default_route_table_id
  tags = { 
    Name = "${local.vpc_name}-default"
  }
}

# VPC와 함께 생성되는 Default Securiy Group에 이름 추가
resource "aws_default_security_group" "default_securitygroup" {
  vpc_id = aws_vpc.eks_vpc.id
  tags   = {
    Name = "${local.vpc_name}-default"
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
    Name = "${local.vpc_name}-public-${count.index+1}",
    "kubernetes.io/cluster/${local.cluster_name}" = "shared",
    "kubernetes.io/role/elb" = "1"
  }
}

## Public Subnet에 연결할 Internet Gateway 정의
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.eks_vpc.id
  tags = {
    Name = "${local.vpc_name}-internetgateway"
  }
}

## Public Subnet과 Internet Gateway 연결을 위한 Route Table 정의
resource "aws_route_table" "public_routetable" {
  vpc_id = aws_vpc.eks_vpc.id
  tags = { 
    Name = "${local.vpc_name}-public-routetable"
  }
}

## Internet Gateway와 Route Table 연결
resource "aws_route" "public_route" {
  route_table_id = aws_route_table.public_routetable.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.internet_gateway.id
}

## Public Subnet과 Route Table 연결
resource "aws_route_table_association" "public_association" {
  count = length(local.public_subnets)
  subnet_id = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_routetable.id
}

## Private Subnet 정의
resource "aws_subnet" "private_subnets" {
  count = length(local.private_subnets)
  vpc_id = aws_vpc.eks_vpc.id
  cidr_block = local.private_subnets[count.index]
  availability_zone = local.azs[count.index]
  tags = {
    Name = "${local.vpc_name}-private-${count.index + 1}",
    "kubernetes.io/cluster/${local.cluster_name}" = "shared", 
    "kubernetes.io/role/internal-elb"             = "1"
  }
}

## NAT Gateway를 위한 Elastic IP
resource "aws_eip" "elastic_ip" {
  vpc = true
  tags = {
    Name = "${local.vpc_name}-elasticip"
  }
}

## NAT Gateway
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.elastic_ip.id
  subnet_id = aws_subnet.public_subnets[0].id  ## NAT Gateway는 Public Subnet에 위치해야한다.
  tags = {
    Name = "${local.vpc_name}-natgateway"
  }
}

## Private Subnet과 NAT Gateway를 연결할 Route Table 정의
resource "aws_route_table" "private_routetable" {
  vpc_id = aws_vpc.eks_vpc.id
  tags = { 
    Name = "${local.vpc_name}-private-routetable"
  }
}

## Route Table과 NAT Gateway 연결
resource "aws_route" "private_route" {
  route_table_id         = aws_route_table.private_routetable.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gateway.id
}

## Route Table과 Private Subnets 연결
resource "aws_route_table_association" "private_association" {
  count = length(local.private_subnets)
  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.private_routetable.id
}