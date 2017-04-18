provider "aws" {
  region = "${var.region}"
}

resource "aws_key_pair" "auth" {
  key_name   = "${var.key_name}"
  public_key = "${file("${var.ssh_pub_key_path}")}"
}

resource "aws_instance" "web" {
  ami = "${var.ami}"
  instance_type = "${var.instance_type}"
  key_name = "${aws_key_pair.auth.key_name}"
  vpc_security_group_ids = ["sg-490ea722"]

  tags {
    Name = "${var.tag_name}"
  }
  provisioner "remote-exec" {
    inline = "echo sshd is running"

    connection {
      agent = false
      type     = "ssh"
      user     = "ubuntu"
      private_key = "${file(var.private_key_path)}"
    }
  }
}
# create security group and attach to instance

resource null_resource "ansible" {
  provisioner "local-exec" {
    command = "cd .. && ansible-playbook playbooks/apache.yml"
  }
}
