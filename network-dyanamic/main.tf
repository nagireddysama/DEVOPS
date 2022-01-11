provider "aws" {
    region     = "us-west-2"
}

resource "aws_vpc" "main_vpc" {
    cidr_block = "10.10.0.0/16"
    tags = {
        Name = "Dynamic-Vpc"
    }
}

data "aws_availability_zones" "azs" {}

resource "aws_subnet" "main_subnets"{
    count = "${length(data.aws_availability_zones.azs.names)}"
    availability_zone = "${element(data.aws_availability_zones.azs.names,count.index)}"
    vpc_id = "${aws_vpc.main_vpc.id}"
    cidr_block = "${element(var.subnet_cidr,count.index)}"
    tags = {
        Name = "Subnet-${count.index + 0}"
    }

}


resource "aws_instance" "main" {
    count = 4
    ami = "ami-0892d3c7ee96c0bf7"
    instance_type = "t2.micro"
    subnet_id = "${aws_subnet.main_subnets[count.index].id}"
    availability_zone = "${element(data.aws_availability_zones.azs.names,count.index)}"

}