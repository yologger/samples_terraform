resource "aws_security_group" "security_group_ec2" {
  name = "security_group_ec2"
  description = "Allow SSH port from all"
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}