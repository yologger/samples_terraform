# resource "kubernetes_deployment" "test-app-deployment" {
#   metadata {
#     name = "test-app"
#   }
#   spec {
#     replicas = 1
#     selector {
#       match_labels = {
#         "app.kubernetes.io/name" = "test-app"
#       }
#     }
#     template {
#       metadata {
#         labels = {
#           "app.kubernetes.io/name" = "test-app"
#         }
#       }
#       spec {
#         container {
#           name  = "test-app"
#           image = "<YOUR_IAM_USER_ID>.dkr.ecr.ap-northeast-2.amazonaws.com/test_app:0.0.1"
#         }
#       }
#     }
#   }
# }
