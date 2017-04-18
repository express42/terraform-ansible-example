variable ssh_pub_key_path {
  description = "path to ssh public key used to create this key on AWS"
}

variable ssh_user {
  description = "user used to log in to instance"
}

variable private_key_path {
  description = "path to the private key used to connect to instance"
}

variable env {
  description = "current working environment"
}

variable ami {
  description = "instance AMI"
  default     = "ami-060cde69"
}

variable instance_type {
  description = "instance type"
  default     = "t2.micro"
}

variable sg_ids {
  description = "list of security groups"
}

variable key_name {
  description = "name of ssh key to create"
}

variable count {
  description = "aws instances count"
  default     = "1"
}

variable name {
  description = "aws instances name"
  default     = "db"
}
