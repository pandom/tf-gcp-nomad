# ### AUTOSCALE
locals {
  nomad_server_name = "nomad-server"
}


resource "google_compute_instance_template" "nomad_server" {
  name_prefix = local.nomad_server_name
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


  tags = [ "nomad-server", "consul-server"]
  labels = {
    "nomad" = "server",
    "consul" = "server"
  }

  metadata = {
    ssh-keys = local.ssh_pub_key_without_new_line
  }
  metadata_startup_script = templatefile("${path.module}/template/server.hcl.tpl", {
    region                         = var.google_nomad_region
    license_path                   = var.license_path
    autoscaler_name                = local.nomad_server_name
    autojoin_tags                  = var.autojoin_tags
    bind_addr                      = var.nomad_bind_addr
    nomad_data_dir                 = var.nomad_data_dir
    dc_name                        = var.nomad_datacenter
    region                         = var.nomad_region
    syslog_log_level               = var.syslog_log_level
    syslog_enabled                 = var.syslog_enabled
    syslog_facility                = var.syslog_facility
    log_level                      = var.syslog_log_level
    server_enabled                 = var.nomad_server_status
    nomad_bootstrap_expect         = var.nomad_bootstrap_expect
    auth_region                    = var.nomad_auth_region
    acl_enabled                    = var.acl_enabled
    audit_enabled                  = var.audit_enabled
    nomad_version                  = var.nomad_version
    nomad_ui_enabled               = var.nomad_ui_enabled
    nomad_vault_url                = var.nomad_vault_url

  })
  lifecycle {
    create_before_destroy = true
  }
}

resource "google_compute_region_instance_group_manager" "nomad_server" {
  name = local.nomad_server_name
  named_port {
    name = "nomad"
    port = "4646"
  }
  version {
    instance_template = google_compute_instance_template.nomad_server.id
    name              = local.nomad_server_name
  }

  base_instance_name = local.nomad_server_name
}

resource "google_compute_region_autoscaler" "nomad_server" {
  name   = local.nomad_server_name
  target = google_compute_region_instance_group_manager.nomad_server.id

  autoscaling_policy {
    max_replicas    = var.max_nomad_server_replicas
    min_replicas    = var.min_nomad_server_replicas
    cooldown_period = 60
  }
}
