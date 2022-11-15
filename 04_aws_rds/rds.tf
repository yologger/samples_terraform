resource "aws_db_instance" "test_db" {
  db_name               = "my_db"
  allocated_storage     = 20
  engine                = "mysql"
  engine_version        = "8.0.28"
  instance_class        = "db.t2.micro"
  username              = "admin"
  password              = "adminadmin"
  skip_final_snapshot   = true
}