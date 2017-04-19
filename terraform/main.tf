provider "aws" {
  region = "${var.region}"
}

module "key_pair" {
  source           = "./modules/key_pair"
  key_name         = "${var.key_name}"
  ssh_pub_key_path = "${var.ssh_pub_key_path}"
}

module "base_linux" {
  source = "./modules/base"
}

module "web" {
  source           = "./modules/web"
  ssh_pub_key_path = "${var.ssh_pub_key_path}"
  ssh_user         = "${var.ssh_user}"
  private_key_path = "${var.private_key_path}"
  env              = "${var.env}"
  key_name         = "${module.key_pair.key_name}"
  sg_ids           = "${module.base_linux.sg_id}"
  name             = "${var.web_server_params["name"]}"
  count            = "${var.web_server_params["count"]}"
}

module "db" {
  source           = "./modules/db"
  ssh_pub_key_path = "${var.ssh_pub_key_path}"
  ssh_user         = "${var.ssh_user}"
  private_key_path = "${var.private_key_path}"
  env              = "${var.env}"
  key_name         = "${module.key_pair.key_name}"
  sg_ids           = "${module.base_linux.sg_id}"
  name             = "${var.db_server_params["name"]}"
  count            = "${var.db_server_params["count"]}"
}

resource null_resource "ansible_web" {
  depends_on = ["module.web"]

  provisioner "local-exec" {
    command = "cd ../ansible && ansible-playbook playbooks/web.yml -e env=${var.env} -e group_name=${var.web_server_params["name"]}"
  }
}

resource null_resource "ansible_db" {
  depends_on = ["module.db"]

  provisioner "local-exec" {
    command = "cd ../ansible && ansible-playbook playbooks/db.yml -e env=${var.env} -e group_name=${var.db_server_params["name"]}"
  }
}
