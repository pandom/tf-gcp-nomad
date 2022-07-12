# ### AUTOSCALE
locals {
  nomad_client_name = "nomad-client"
}


resource "google_compute_instance_template" "nomad_client" {
  name_prefix = local.nomad_client_name
  machine_type = var.node_type
  can_ip_forward = var.access

  disk {
    source_image = data.hcp_packer_image.nomad.cloud_image_id
  }

  network_interface {
    subnetwork = data.google_compute_subnetwork.nomad.id
  }

  service_account {
    email =  google_service_account.nomad_node.email
    scopes = [ "cloud-platform" ]
  }

  tags = [ "nomad-server" ]
  labels = {
    "nomad" = "client",
    "consul" = "client"
  }

  metadata = {
    ssh-keys = local.ssh_pub_key_without_new_line
  }
  metadata_startup_script = templatefile("${path.module}/template/client.hcl.tpl", {
    autoscaler_name                = local.nomad_client_name
    autojoin_tags                  = var.autojoin_tags
    bind_addr                      = var.nomad_bind_addr
    nomad_data_dir                 = var.nomad_data_dir
    dc_name                     = var.nomad_datacenter
    region                         = var.nomad_region
    syslog_log_level               = var.syslog_log_level
    syslog_enabled                 = var.syslog_enabled
    syslog_facility                = var.syslog_facility
    log_level                      = var.syslog_log_level
    auth_region                    = var.nomad_auth_region
    autojoin_tags                  = var.autojoin_tags
    acl_enabled                    = var.acl_enabled
    audit_enabled                  = var.audit_enabled
    nomad_version                  = var.nomad_version
    server_enabled                 = var.nomad_server_status
    nvidia_enabled                 = var.nvidia_enabled
  })
  lifecycle {
    create_before_destroy = true
  }
}

resource "google_compute_region_instance_group_manager" "nomad_client" {
  name = local.nomad_client_name

  version {
    instance_template = google_compute_instance_template.nomad_client.id
    name              = local.nomad_client_name
  }

  base_instance_name = local.nomad_client_name
}

resource "google_compute_region_autoscaler" "nomad_client" {
  name   = local.nomad_client_name
  target = google_compute_region_instance_group_manager.nomad_client.id

  autoscaling_policy {
    max_replicas    = var.max_nomad_client_replicas
    min_replicas    = var.min_nomad_client_replicas
    cooldown_period = 60
  }
}


### NVIDIA