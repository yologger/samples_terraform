resource "aws_key_pair" "ec2_keypair" {
  key_name = "ec2_keypair"
  public_key = file("~/.ssh/terraform_example_keypair.pub")
}