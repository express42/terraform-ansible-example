variable pub_key_path {
  description = "Path to ssh public key used to create this key on AWS"
}

variable ssh_user {
  description = "User used to log in to instance"
  default     = "ubuntu"
}

variable private_key_path {
  description = "Path to the private key used to connect to instance"
}

variable region {
  description = "Region"
  default     = "eu-central-1"
}

variable azs {
  description = "Run the EC2 Instances in these Availability Zones"
  type = "list"
  default = ["eu-central-1a", "eu-central-1b"]
}

variable env {
  description = "Environment prefix"
  default = "dev"
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
