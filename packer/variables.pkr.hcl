variable "project" {
    type = string
    default = "hc-20734ed73db943d4ade2b1e9cb9"
}

variable "zone" {
    type = string
    default = "australia-southeast1-b"
}
variable "region" {
    type = string
    default = "australia-southeast1"
}

variable "sshuser" {
    type = string
    default = "root"
}
#source_image = "ubuntu-minimal-2004-focal-v20220118"
variable "image" {
    type = string
    default = "ubuntu-minimal-2004-focal-v20220118"
}
variable "ansible_user_password" {
    type = string
    default = ""
}