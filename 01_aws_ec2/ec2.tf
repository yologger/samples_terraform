resource "aws_instance" "my_ec2" {
  ami = "ami-0a93a08544874b3b7"  # amzn2-ami-hvm-2.0.20200207.1-x86_64-gp2
  instance_type = "t2.micro"
  key_name = aws_key_pair.ec2_keypair.key_name
  vpc_security_group_ids = [
    aws_security_group.security_group_ec2.id,
  ]
}