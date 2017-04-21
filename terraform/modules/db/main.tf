resource "aws_instance" "db" {
  ami           = "${var.ami}"
  count         = "${var.count}"
  instance_type = "${var.instance_type}"
  key_name      = "${var.key_name}"

  vpc_security_group_ids = [
    "${var.sg_ids}",
    "${aws_security_group.db.id}",
  ]

  tags {
    Name  = "${var.env}_${format("${var.name}%02d", count.index+1)}"
    Group = "${var.env}_${var.name}_cluster"
  }

  provisioner "remote-exec" {
    inline = "#Connected!"

    connection {
      agent       = false
      type        = "ssh"
      user        = "${var.ssh_user}"
      private_key = "${file(var.private_key_path)}"
    }
  }
}

resource "aws_security_group" "db" {
  name        = "${var.env}_example_db_sg"
  description = "Allow DB access"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
