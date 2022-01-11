provider "aws" {
    region = "us-west-2"
}

resource "aws_vpc" "main-vpc" {
    cidr_block = var.vpc_cidr
}

resource "aws_subnet" "subnetes" {
    cidr_block = var.subnet_cidr
    availability_zone = "us-west-2a"
    vpc_id = "${aws_vpc.main-vpc.id}"
}

resource "aws_internet_gateway" "igw" {
    vpc_id = "${aws_vpc.main-vpc.id}"
}

resource "aws_route_table" "main-rtb" {
    vpc_id = "${aws_vpc.main-vpc.id}"
    
}

resource "aws_route" "main-route" {
    route_table_id = "${aws_route_table.main-rtb.id}"
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"

}

resource "aws_route_table_association" "arta" {
    subnet_id = aws_subnet.subnetes.id
    route_table_id = aws_route_table.main-rtb.id
  
}

resource "aws_security_group" "main-sgp" {
    name = "allow_all"
    vpc_id = "${aws_vpc.main-vpc.id}"
    description = "This is my first sgp from tf"

    ingress {
        description = "TLS from vpc"
        from_port   = 0
        to_port     = 6000
        protocol    = "tcp"
        cidr_blocks  = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port   = 6000
        protocol  = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "allow_all"
    }

}

resource "aws_instance" "my-instance" {
    ami = "ami-0892d3c7ee96c0bf7"
    instance_type = "t2.micro"
    subnet_id = "${aws_subnet.subnetes.id}"
    availability_zone = "us-west-2a"
    security_groups = ["${aws_security_group.main-sgp.id}"]
    associate_public_ip_address = true
    key_name = var.key_name

    provisioner "remote-exec" {
        inline = [
            "sudo apt-get update -y",
            "sudo apt-get install tree -y"
        ]
    
        connection {
          type = "ssh"
          user    = var.os_user
          host = "${aws_instance.my-instance.public_ip}"
          private_key = "${file("${var.key_path}")}"
        }
    }
    provisioner "local-exec" {
        command = "sudo apt-get insall -y"
      
    }

      
}




