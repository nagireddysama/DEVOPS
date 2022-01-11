output "public_ip" {
    value = format("http://%s",aws_instance.my-first-instance.public_ip)
}