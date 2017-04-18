variable ssh_pub_key_path {
  description = "path to ssh public key used to create this key on AWS"
}

variable ssh_user {
  default = "ubuntu"
  description = "user used to log in to instance"
}

variable private_key_path {
  description = "path to the private key used to connect to instance"
}

variable region {
  description = "region"
  default     = "eu-central-1"
}

variable env {
  description = "current working environment"
}

variable ami {
  description = "instance AMI"
  default     = "ami-060cde69"
}

variable db_server_params {
  default = {
    "name"  = "db"
    "count" = "1"
  }
}

variable web_server_params {
  default = {
    "name"  = "web"
    "count" = "1"
  }
}

variable key_name {
  description = "name of ssh key to create"
}
