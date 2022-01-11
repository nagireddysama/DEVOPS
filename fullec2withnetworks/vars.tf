variable "access_key" {
    default = ""
    
}

variable "secret_key" {
    default = ""
}

variable "key_name" {
    default = "scripting"
    description = "(optional) describe your variable"
}

variable "key_path" {
    default = "./scripting.pem"
}

variable "os_user" {
    default = "ubuntu"
}