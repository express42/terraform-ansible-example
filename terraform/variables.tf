variable region {
  description = "region"
  default = "eu-central-1"
}

variable instance_type {
  description = "instance type"
  default = "t2.micro"
}

variable pub_key_path {
  description = "path to ssh public key used to create this key on AWS"
}

variable tag_name {
  description = "Value of a Name tag used in for provisioning with ansible"
  default = "web"
}

variable private_key_path {
  description = "path to the private key used to connect to instance"
}

variable key_name {
  default = "name of ssh key to create"
}
