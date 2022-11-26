module "eks" {
  source = "terraform-aws-modules/eks/aws"

  cluster_name                    = local.cluster_name
  cluster_version                 = "1.21"
  cluster_endpoint_private_access = false
  cluster_endpoint_public_access  = true

  cluster_addons = {
    coredns = {
      resolve_conflicts = "OVERWRITE"
    }
    kube-proxy = {}
    vpc-cni = {
      resolve_conflicts = "OVERWRITE"
    }
  }

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  // Node Group의 EC2 설정
  eks_managed_node_group_defaults = {
    disk_size      = 50
    instance_types = ["t3.large"]
  }

  // Node Group 설정
  eks_managed_node_groups = {
    ("${local.cluster_name}-node-group") = {
      // Node Group Auto Scaling 옵션
      min_size     = 1  ## 최소
      max_size     = 10 ## 최대
      desired_size = 1  ## 기본

      instance_types = ["t3.large"]
      capacity_type  = "SPOT"
    }
  }

  node_security_group_additional_rules = {
    // Node Group에 AWS Load Balancer Controller를 위한 Security Group 추가
    ingress_allow_access_from_control_plane = {
      type                          = "ingress"
      protocol                      = "tcp"
      from_port                     = 9443
      to_port                       = 9443
      source_cluster_security_group = true
      description                   = "Allow access from control plane to webhook port of AWS load balancer controller"
    },
    // Metrics API와 Node Group간 통신
    node_to_node_communication_for_metrics_server_rules = {
      type                          = "ingress"
      protocol                      = "-1"
      from_port                     = 0
      to_port                       = 10250
      source_cluster_security_group = true
      description                   = "Cluster API to Nodegroup for metrics server"
    }
  }
}
