resource "aws_db_instance" "test_db" {
    allocated_storage = 20
    engine = "mysql"
    engine_version = "5.6.35"
    instance_class = "db.t2.micro"
    username = "admin"
    password = "admin"
    skip_final_snapshot = true
}