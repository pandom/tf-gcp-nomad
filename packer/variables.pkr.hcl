variable "project" {
    type = string
    default = "burkey-gcp-demos-317523"
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
    default = "ubuntu"
}

variable "image" {
    type = string
    default = "ubuntu-2004-focal-v20210325"
}
variable "ansible_user_password" {
    type = string
    default = ""
}