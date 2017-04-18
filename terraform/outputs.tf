output "web_address" {
  value = "${aws_instance.web.public_ip}"
}
