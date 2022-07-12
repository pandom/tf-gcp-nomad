data "hcp_packer_iteration" "hcp_nomad_packer" {
  bucket_name = var.hcp_bucket
  channel     = var.hcp_channel
}

data "hcp_packer_image" "nomad" {
    bucket_name = var.hcp_bucket
    cloud_provider = "gce"
    iteration_id = data.hcp_packer_iteration.hcp_nomad_packer.ulid
    region = var.zone
}

