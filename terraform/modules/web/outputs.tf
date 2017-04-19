output "public_ip" {
  value = ["${aws_instance.web.*.public_ip}"]
}

output "id_list" {
  value = ["${aws_instance.web.*.id}"]
}
