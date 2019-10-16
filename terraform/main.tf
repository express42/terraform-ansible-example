provider "aws" {
  region = "${var.region}"
}

module "key_pair" {
  source       = "./modules/key_pair"
  key_name     = "${var.key_name}"
  pub_key_path = "${var.pub_key_path}"
}

module "base_linux" {
  source = "./modules/base"
  env    = "${var.env}"
}

module "web" {
  ami              = "${data.aws_ami.image.id}"
  source           = "./modules/web"
  pub_key_path     = "${var.pub_key_path}"
  ssh_user         = "${var.ssh_user}"
  private_key_path = "${var.private_key_path}"
  env              = "${var.env}"
  key_name         = "${module.key_pair.key_name}"
  sg_ids           = "${module.base_linux.sg_id}"
  name             = "${var.web_server_params["name"]}"
}

module "db" {
  ami              = "${data.aws_ami.image.id}"
  source           = "./modules/db"
  pub_key_path     = "${var.pub_key_path}"
  ssh_user         = "${var.ssh_user}"
  private_key_path = "${var.private_key_path}"
  env              = "${var.env}"
  key_name         = "${module.key_pair.key_name}"
  sg_ids           = "${module.base_linux.sg_id}"
  name             = "${var.db_server_params["name"]}"
}
