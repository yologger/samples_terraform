locals {
  ecr_repositoy_name = "ecr_repository"
}

// ECR Repository
resource "aws_ecr_repository" "ecr_repository" {
  name = local.ecr_repositoy_name
}