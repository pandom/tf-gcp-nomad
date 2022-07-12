

## BASTION BEFORE BOUNDARY


#SUIPERSNEAKYCODE
# # #### MY STUFF

resource "google_compute_project_metadata" "burkey" {
    metadata = {
      "ssh-keys" = <<EOF
        ubuntu:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC8xYZMmdFegfk4NCog1casM50GMQOzunGt1gjO0TNLPI4aJvfwL3BDyEMmvzvkyLKlAxhuQ9nPjYW5X6BK1kihHIBgpz3lweaXJWE0ITJEGjLpniSBvvXsQQA/Dq7wIc/l383aEaiqYDzmUhcndBkCPcHPd7WyGTQJl76Oh+ot0gabQzy/qfXdZNCnAIyCrVV9ZVlZmvEVcPLWq2wtP3y/9m027GVTh01KxaZjVHvT5gvjsniN3ZI908HsSTTwHXykXQQCTIOTfKPVvpr3lSiFomzGKVLQU8bkRz86ICn5UlXUNlzgNQbRA/JBM2W+o8XbzYhyoL+srQ7upPuWkcRrYYNnCk6Ag9fnUXTFAjOJdKZdhrxF2AuM/uEp+M0JwSwsCgilnm5nztZfRf9QHgKuYAvelu4325TtazIPXUiwXAsIKCl0UyWI5YTRu3lO8P3fpG0HyMIG1y0MukTMUEP13kp3sqjif374JIKdThksjEetIYw2H9DU5WEVVXrHXUs= burkey@erebor.local
      EOF
    }
  
}

resource "google_compute_disk" "nomad" {
  project = var.project
  image = data.hcp_packer_image.nomad.cloud_image_id
  name = "node-disk"
  zone = var.zone
}

resource "google_compute_address" "server01" {
    name = "server01"
    project = var.project
}


resource "google_compute_instance" "server01" {
    name         = "bastion"
    machine_type = "e2-micro"
    zone = var.zone

    boot_disk {
      source = google_compute_disk.nomad.id
    }

    network_interface {
      network = google_compute_network.network.name
      access_config {
        nat_ip = google_compute_address.server01.address
      }
    }

    metadata = {
        ssh-keys = local.ssh_pub_key_without_new_line
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
    zone = var.zone
  instances = [ 
    google_compute_instance.server01.self_link
  ]
  network = google_compute_network.network.id
  named_port {
    name = "bastion-ssh"
    port = "443"
  }
}
##NVIDIA
# resource "google_compute_disk" "nvidia" {
#   project = var.project
#   image = data.google_compute_image.image.id
#   name = "nvidia-disk"
#   zone = var.zoneb
#   size = 200
# }

# resource "google_compute_address" "nvidia" {
#     name = "nvidia"
#     project = var.project
# }

# ##https://cloud.google.com/compute/docs/gpus/gpu-regions-zones
# resource "google_compute_instance" "nvidia" {
#     name         = "nvidia"
#     machine_type = "n1-standard-2"
#     guest_accelerator {
#       type = "nvidia-tesla-t4"
#       count = 1
#     }
    
#     boot_disk {
#       source = google_compute_disk.nvidia.name
#     }

#     network_interface {
#       network = google_compute_network.network.name
#       access_config {
#         nat_ip = google_compute_address.nvidia.address
#       }
#     }

#     metadata = {
#         ssh-keys = local.ssh_key_string
#     }
#     service_account {
#       email = google_service_account.nomad_node.email
#       scopes = ["cloud-platform"]
#     }
#     //required for GPU
#     scheduling {
#       on_host_maintenance = "TERMINATE"
#     }
#     allow_stopping_for_update = true
#     tags = [ "nvidia" ]
# }

# resource "google_compute_instance_group" "nvidia" {
#   name = "nvidia-compute-instance-group"
#   description = "nvidia"

#   instances = [ 
#     google_compute_instance.nvidia.self_link
#   ]
#   network = google_compute_network.network.id
#   named_port {
#     name = "nvidia-ssh"
#     port = "443"
#   }
# }