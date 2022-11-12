## EKS Cluster가 사용할 Role 정의
resource "aws_iam_role" "eks_cluster_role" {
  name = "${local.cluster_name}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "eks.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

## Role에 Policy 추가
resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role.name
}

resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.eks_cluster_role.name
}

## EKS Cluster 생성
resource "aws_eks_cluster" "eks_cluster" {
  name     = local.cluster_name
  role_arn = aws_iam_role.eks_cluster_role.arn
  vpc_config {
    subnet_ids = aws_subnet.private_subnets[*].id
  }
  depends_on = [
    aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.cluster_AmazonEKSVPCResourceController,
  ]
}

## Fargate에서 필요로 하는 Role
resource "aws_iam_role" "pod_execution_role" {
  name = "${local.cluster_name}-pod-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "eks-fargate-pods.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "pod_execution_AmazonEKSFargatePodExecutionRolePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
  role       = aws_iam_role.pod_execution_role.name
}

## EKS Cluster에 Fargate를 Node로 추가
resource "aws_eks_fargate_profile" "default" {
  cluster_name           = aws_eks_cluster.eks_cluster.name
  fargate_profile_name   = "fargate-profile"
  pod_execution_role_arn = aws_iam_role.pod_execution_role.arn
  subnet_ids             = aws_subnet.private_subnets[*].id
  selector {
    namespace = "default"
  }
  selector {
    namespace = "kube-system"
  }
}