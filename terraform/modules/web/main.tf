resource "aws_instance" "web" {
  ami           = "${var.ami}"
  count         = "${var.count}"
  instance_type = "${var.instance_type}"
  key_name      = "${var.key_name}"

  vpc_security_group_ids = [
    "${var.sg_ids}",
    "${aws_security_group.web.id}",
  ]

  tags {
    Name  = "${var.env}_${format("${var.name}%02d", count.index+1)}"
    Group = "${var.env}_${var.name}"
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

resource "aws_security_group" "web" {
  name        = "example_web_sg"
  description = "Allow Mysql access"

  ingress {
    from_port   = 0
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
