//TODO
// NETWORK
# security
# 
provider "google" {
  region = "australia-southeast1"
  project = "burkey-gcp-demos-317523"
  zone = var.zoneb
 }
# provider "google-beta" {
#   region = "australia-southeast1"
#   project = "burkey-gcp-demos"
# }
provider "azure" {
    region = "australia-east"
  zone = var.zoneb
}

locals {
  ssh_key_string = var.ssh_key_path != "" ? "${var.ssh_username}:${file(var.ssh_key_path)}" : null

  nomad_node_server_name = "nomad-server"
}
