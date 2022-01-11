variable "key_name" {
    default = "First_Key"
    description = "(optional) describe your variable"
}

variable "key_path" {
    default = "./scripting.pem"
}

variable "os_user" {
    default = "ubuntu"
}

variable "vpc_cidr" {
    default = "10.10.0.0/16"
}

variable "subnet_cidr" {
    default = "10.10.0.0/24"
}