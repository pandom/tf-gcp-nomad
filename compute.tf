data "google_compute_image" "image" {
    family = "ubuntu-2004-lts"
    project = "ubuntu-os-cloud"

}

data "google_compute_image" "nomadserver" {
  family = "nomad-server"
}
data "google_compute_image" "nomadclient" {
  family = "nomad-client"
}

## BASTION BEFORE BOUNDARY


#SUIPERSNEAKYCODE
# # #### MY STUFF

resource "google_compute_disk" "nomad" {
  project = var.project
  image = data.google_compute_image.image.id
  name = "node-disk"
  zone = var.zoneb
}

resource "google_compute_address" "server01" {
    name = "server01"
    project = var.project
}


resource "google_compute_instance" "server01" {
    name         = "bastion"
    machine_type = "e2-micro"
    boot_disk {
      source = google_compute_disk.nomad.name
    }

    network_interface {
      network = google_compute_network.network.name
      access_config {
        nat_ip = google_compute_address.server01.address
      }
    }

    metadata = {
        ssh-keys = local.ssh_key_string
    }
    service_account {
      email = google_service_account.nomad_node.email
      scopes = ["cloud-platform"]
    }
    allow_stopping_for_update = true
    tags = [ "bastion" ]
}

resource "google_compute_instance_group" "bastion" {
  name = "bastion-compute-instance-group"
  description = "bastion"

  instances = [ 
    google_compute_instance.server01.self_link
  ]
  network = google_compute_network.network.id
  named_port {
    name = "bastion-ssh"
    port = "443"
  }
}
