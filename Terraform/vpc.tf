#
# Create and configure the VPCs and the components needed in it...
#

# generate VPC
resource "aws_vpc" "main_vpc" {
  cidr_block = "10.1.0.0/16"
  tags = {
    Name = "GriCom Central VPC"
  }
}

# generate Internet Gateway
resource "aws_internet_gateway" "main_gateway" {
  vpc_id = aws_vpc.main_vpc.id
}

# generate a VPC subnet on availability zone North A
resource "aws_subnet" "default_subnet" {
  vpc_id = aws_vpc.main_vpc.id
  cidr_block = "10.1.1.0/24"
  availability_zone = "eu-north-1a"
}

# generate a default route table
resource "aws_route_table" "default_route_table" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_gateway.id
  }
}

resource "aws_route_table_association" "main_gateway" {
  subnet_id = aws_subnet.default_subnet.id
  route_table_id = aws_route_table.default_route_table.id
}

# security section: generate ACL
resource "aws_network_acl" "allowall" {
  vpc_id = aws_vpc.main_vpc.id

  egress {
    protocol = "-1"
    rule_no = 100
    action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port = 0
    to_port = 0
  }

  ingress {
    protocol = "-1"
    rule_no = 200
    action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port = 0
    to_port = 0
  }
}

resource "aws_security_group" "allowall" {
  name = "GriCom Central Security Group Allow All"
  description = "Allows all traffic"
  vpc_id = aws_vpc.main_vpc.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

