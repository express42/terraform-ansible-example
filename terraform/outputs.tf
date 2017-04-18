output "web_address" {
  value = "${module.web.public_ip}"
}


output "db_address" {
  value = "${module.db.public_ip}"
}
