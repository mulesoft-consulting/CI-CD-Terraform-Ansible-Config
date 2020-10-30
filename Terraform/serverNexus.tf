#
# Create and configure an EC2 server in the VPC
#
# Name of the server: Nexus Artefact Repository Server
# Content of the server: empty Ubuntu server for Sonatype Nexus
#

# generate an elastic IP
resource "aws_eip" "nexus" {
  instance = aws_instance.nexus.id
  vpc = true
  depends_on = [aws_internet_gateway.main_gateway]
}

resource "aws_instance" "nexus" {
  ami = data.aws_ami.ubuntu.id
  availability_zone = "eu-north-1a"
  instance_type = "t3.nano"
  key_name = aws_key_pair.aws_id.key_name
  vpc_security_group_ids = [aws_security_group.allowall.id]
  subnet_id = aws_subnet.default_subnet.id
}

output "public_ip_nexus" {
  value = aws_eip.nexus.public_ip
}
