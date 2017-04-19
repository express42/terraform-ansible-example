output "public_ip" {
  value = ["${aws_instance.db.*.public_ip}"]
}

output "id_list" {
  value = ["${aws_instance.db.*.id}"]
}
