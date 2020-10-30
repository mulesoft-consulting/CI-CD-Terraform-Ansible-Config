#
# Joined configuration for servers...
#
# Name of the server: none
# Content of the server: none
#

resource "aws_key_pair" "aws_id" {
  key_name = "aws_id"
  public_key = file("~/.ssh/aws_id.pub")
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

