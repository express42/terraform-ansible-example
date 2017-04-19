variable pub_key_path {
  description = "Path to ssh public key used to create this key on AWS"
}

variable ssh_user {
  description = "User used to log in to instance"
}

variable private_key_path {
  description = "Path to the private key used to connect to instance"
}

variable env {
  description = "Environment prefix"
}

variable ami {
  description = "Instance AMI"
}

variable instance_type {
  description = "instance type"
  default     = "t2.micro"
}

variable sg_ids {
  description = "List of security groups ids"
}

variable key_name {
  description = "Name of ssh key to create"
}

variable count {
  description = "Number of instances to create"
  default     = "1"
}

variable name {
  description = "Server name"
  default     = "web"
}
