resource "aws_instance" "my-first-instance" {
    ami = "ami-090717c950a5c34d3"
    instance_type = "t2.micro"
    key_name = var.key_name
    security_groups = ["${aws_security_group.my_first_sgp.id}"]
    availability_zone = "us-west-2a"
    subnet_id = "${aws_subnet.my_first_subnet.id}"
    associate_public_ip_address = true

    connection {
        type = "ssh"
        user = "${var.os_user}"
        host    = "${aws_instance.my-first-instance.public_ip}"
        private_key = "${file("${var.key_path}")}"
    }

    provisioner "remote-exec" {
        inline = [
            "sudo apt-get update -y",
            "sudo apt install openjdk-8-jdk -y",
            "wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -",
            "sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'",
            "sudo apt-get update -y"

            


           
        ]
    
    }
}

