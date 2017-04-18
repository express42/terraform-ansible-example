output "public_ip" {
  value = "${aws_instance.db.public_ip}"
}
