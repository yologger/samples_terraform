locals {
  app_name = "test_app"
}

## ECR Repository
resource "aws_ecr_repository" "ecr_repository" {
  name = local.app_name
}