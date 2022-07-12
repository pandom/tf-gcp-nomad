terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.25.0"
    }
    hcp = {
        source = "hashicorp/hcp"
        version = "0.32.0" 
    }
  }
}

provider "hcp" {
  
}
provider "google" {
    project = var.project
    region = var.region
}

provider "google-beta" {
    region = var.region
    project = var.project
}

locals {
  ssh_pub_key_without_new_line = "${replace(var.ssh_pub_key, "\n", "")}"
  nomad_node_server_name = "nomad-server"
}