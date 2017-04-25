data "aws_ami" "image" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu-16.04-amd64-python2*"]
  }
  owners     = ["self"]
}
