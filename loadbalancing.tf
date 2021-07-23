resource "google_compute_forwarding_rule" "default" {
  # provider              = google-beta
  name                  = "nomad-ui-forwarding-rule"
#   region                = "australia-southeast1"
  port_range            = 4646
  ip_protocol = "TCP"
  backend_service       = google_compute_region_backend_service.default.id
  load_balancing_scheme = "EXTERNAL"
}
resource "google_compute_forwarding_rule" "consul" {
  # provider              = google-beta
  name                  = "consul-ui-forwarding-rule"
#   region                = "australia-southeast1"
  port_range            = 8500
  ip_protocol = "TCP"
  backend_service       = google_compute_region_backend_service.default.id
  load_balancing_scheme = "EXTERNAL"
}
resource "google_compute_forwarding_rule" "ssh" {
  # provider              = google-beta
  name                  = "ssh"
#   region                = "australia-southeast1"
  port_range            = 22
  ip_protocol = "TCP"
  backend_service       = google_compute_region_backend_service.bastion_backend.id
  load_balancing_scheme = "EXTERNAL"
}
# resource "google_compute_forwarding_rule" "ssh-client-test" {
#   # provider              = google-beta
#   name                  = "ssh-client"
# #   region                = "australia-southeast1"
#   port_range            = 22
#   ip_protocol = "TCP"
#   backend_service       = google_compute_region_backend_service.nomad_client.id
#   load_balancing_scheme = "EXTERNAL"
# }

# resource "google_compute_forwarding_rule" "" {
#   provider              = google-beta
#   name                  = "nomad-ssh-forwarding-rule"
#   region                = var.region
#   port_range            = 22
#   backend_service       = google_compute_backend_service.backend.id
# }

resource "google_compute_region_backend_service" "default" {
  name          = "backend-service"
  health_checks = [google_compute_region_health_check.nomadui.id]
  load_balancing_scheme = "EXTERNAL"
  backend {
    group = google_compute_region_instance_group_manager.nomad_server.instance_group
    description = "nomad-servers"
  }
}

resource "google_compute_region_backend_service" "bastion_backend" {
  name          = "bastion-service"
  health_checks = [google_compute_region_health_check.bastion.id]
  load_balancing_scheme = "EXTERNAL"
  backend {
    group = google_compute_instance_group.bastion.id
    description = "bastion-server"
  }
}

resource "google_compute_region_health_check" "nomadui" {
    name        = "nomad-tcp-check"
    description = "Health check via tcp"

    timeout_sec         = 1
    check_interval_sec  = 1
    healthy_threshold   = 4
    unhealthy_threshold = 5
    
    tcp_health_check {
      port_name = var.portname_nomadui
      port_specification = "USE_NAMED_PORT"
    }
    project = var.project
}

resource "google_compute_region_health_check" "bastion" {
    name        = "basion-tcp-check-clients"
    description = "Health check via tcp"

    timeout_sec         = 1
    check_interval_sec  = 1
    healthy_threshold   = 4
    unhealthy_threshold = 5
    
    tcp_health_check {
      port_name = "ssh"
      port_specification = "USE_NAMED_PORT"
    }
    project = var.project
}


## Ingress

resource "google_compute_region_backend_service" "nomad_client" {
  name          = "nomad-client-service"
  health_checks = [google_compute_region_health_check.nomadui.id]
  load_balancing_scheme = "EXTERNAL"
  backend {
    group = google_compute_region_instance_group_manager.nomad_client.instance_group
    description = "nomad-client service"
  }
}

resource "google_compute_forwarding_rule" "fabio_ui" {
  # provider              = google-beta
  name                  = "fabio-ui-forwarding-rule"
#   region                = "australia-southeast1"
  port_range            = 9998
  ip_protocol = "TCP"
  backend_service       = google_compute_region_backend_service.nomad_client.id
  load_balancing_scheme = "EXTERNAL"

}

resource "google_compute_forwarding_rule" "fabio_data" {
  # provider              = google-beta
  name                  = "fabio-data-forwarding-rule"
#   region                = "australia-southeast1"
  port_range            = 9999
  ip_protocol = "TCP"
  backend_service       = google_compute_region_backend_service.nomad_client.id
  load_balancing_scheme = "EXTERNAL"
}