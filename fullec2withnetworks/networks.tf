resource "aws_vpc" "my_first_vpc" {
    cidr_block = "10.10.0.0/16"

    tags = {
        Name = "firstvpc"
    }
}

resource "aws_subnet" "my_first_subnet" {
    cidr_block = "10.10.0.0/24"
    availability_zone = "us-west-2a"
    vpc_id = "${aws_vpc.my_first_vpc.id}"

    tags = {
        Name = "firstsubnet"
    }
}

resource "aws_security_group" "my_first_sgp" {
    vpc_id = "${aws_vpc.my_first_vpc.id}"
    ingress  {
        from_port = 0
        to_port = 6000
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress  {
      cidr_blocks = [ "0.0.0.0/0" ]
      from_port = 8080
      protocol = "tcp"
      to_port = 8080
    } 

    egress  {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress  {
        from_port = 0
        to_port = 6000
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_internet_gateway" "my_first_igw" {
    vpc_id = "${aws_vpc.my_first_vpc.id}"
    tags = {
        Name = "first_igw"
    }
}

resource "aws_route_table" "my_first_rtb" {
    vpc_id = "${aws_vpc.my_first_vpc.id}"

}

resource "aws_route" "my_first_rtb" {
    route_table_id = "${aws_route_table.my_first_rtb.id}"
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.my_first_igw.id}"
}

resource "aws_route_table_association" "my_first_rta" {
    subnet_id = "${aws_subnet.my_first_subnet.id}"
    route_table_id = "${aws_route_table.my_first_rtb.id}"
}