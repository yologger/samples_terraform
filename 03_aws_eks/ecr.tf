locals {
  ecr_repositoy_name = "ecr_repository"
}

## simon-sample 앱을 위한 저장소를 만듭니다
resource "aws_ecr_repository" "simon_sample" {
  name = local.ecr_repositoy_name
}