locals {
    timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

source "googlecompute" "nomad-server" {
    project_id = var.project
    ssh_username = var.sshuser
    zone = var.zone
    source_image = var.image
    image_labels = {
        "nomad" = "server"
        "build" = local.timestamp
    }
    image_family = "nomad-server"
}


source "googlecompute" "nomad-client" {
    project_id = var.project
    ssh_username = var.sshuser
    zone = var.zone
    source_image = var.image
    image_labels = {
        "nomad" = "client"
        "build" = local.timestamp
    }
    image_family = "nomad-client"

}