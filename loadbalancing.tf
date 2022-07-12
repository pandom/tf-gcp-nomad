resource "google_compute_address" "nomad" {
    name = var.name_nomadui
  
}

resource "google_compute_forwarding_rule" "default" {
  # provider              = google-beta
  name                  = "nomad-ui-forwarding-rule"
  ip_address = google_compute_address.nomad.address
  ip_protocol = "TCP"
  port_range            = 4646
  backend_service       = google_compute_region_backend_service.default.id
}

resource "google_compute_region_backend_service" "default" {
  name          = "backend-service"
  health_checks = [google_compute_region_health_check.nomadui.id]
  load_balancing_scheme = "EXTERNAL"
  backend {
    group = google_compute_region_instance_group_manager.nomad_server.instance_group
    balancing_mode = "CONNECTION"
    description = "nomad-servers"
  }
}

resource "google_compute_region_health_check" "nomadui" {
    name        = "nomad-tcp-check"
    description = "Health check via tcp"

    timeout_sec         = 1
    check_interval_sec  = 1
    
    tcp_health_check {
       port = "4646"
    }
    project = var.project
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




resource "google_compute_region_backend_service" "bastion_backend" {
  name          = "bastion-service"
  health_checks = [google_compute_region_health_check.bastion.id]
  load_balancing_scheme = "EXTERNAL"
  backend {
    group = google_compute_instance_group.bastion.id
    description = "bastion-server"
  }
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

resource "google_compute_address" "traefik" {
    name = "traefik"
  
}

resource "google_compute_forwarding_rule" "traefik" {
  # provider              = google-beta
  name                  = "traefik"
  ip_address = google_compute_address.traefik.address
  ip_protocol = "TCP"
  port_range            = 8080
  backend_service       = google_compute_region_backend_service.nomad_client.id
}

resource "google_compute_region_backend_service" "traefik" {
  name          = "traefix-service"
  health_checks = [google_compute_region_health_check.traefik.id]
  load_balancing_scheme = "EXTERNAL"
  backend {
    group = google_compute_region_instance_group_manager.nomad_client.instance_group
    balancing_mode = "CONNECTION"
    description = "traefik"
  }
}

resource "google_compute_region_health_check" "traefik" {
    name        = "traefik-check"
    description = "Health check via tcp"

    timeout_sec         = 1
    check_interval_sec  = 1
    
    tcp_health_check {
       port = "8080"
    }
    project = var.project
}

# resource "google_compute_forwarding_rule" "fabio_data" {
#   # provider              = google-beta
#   name                  = "fabio-data-forwarding-rule"
# #   region                = "australia-southeast1"
#   port_range            = 9999
#   ip_protocol = "TCP"
#   backend_service       = google_compute_region_backend_service.nomad_client.id
#   load_balancing_scheme = "EXTERNAL"
# }