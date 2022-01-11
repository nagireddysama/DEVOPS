provider "aws" {
    access_key = "",
    secret_key = "",
    region = "us-west-2"
}

resource "aws_vpc" "main" {
    cidr_block = "10.10.0.0/16"

}

resource "aws_subnet" "public-subnet" {
    cidr_block = "10.10.0.0/24"
    vpc_id = ${aws_vpc.main.id}
}

resource "aws_internet_gatway" "igw" {
    vpc_id = ${aws_vpc.main.id}
}

resource "aws_route_table" "rtb" {
    vpc_id = ${aws_vpc.main.id}

}

resource "aws_route" "route" {
    route_table_id = ${aws_route_table.rtb.id}
}

resource "aws_routetable_association" "artba" {
    aws_subnet = ${aws_subnet.public-subnet.id}
    route_table_id = ${aws_route_table.rtb.id}
}

resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.main.cidr_block]
    ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}