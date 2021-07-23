resource "google_compute_network" "network" {
    project = var.project
    name = "burkey-network"
    description = "Network for Nomad"
    auto_create_subnetworks = true
    routing_mode = "REGIONAL"
    mtu = 1500  
}


data "google_compute_subnetwork" "nomad" {
  name   = google_compute_network.network.name
  region = "australia-southeast1"
}

resource "google_compute_firewall" "firewall-lb-nomad" {
  name    = "lb-nomad"
  network = google_compute_network.network.name

  allow {
    protocol = "tcp"
    ports    = ["9999", "9998"]
  }

  source_ranges = [ var.myip ]

}

resource "google_compute_firewall" "firewall-nomad" {
  name    = "firewall-nomad"
  network = google_compute_network.network.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["4646", "4647", "4848"]
  }
  #Consul
  allow {
    protocol = "tcp"
    ports = ["8500", "8620", "21000-21225", "8300-8302"] 
  }
  allow {
    protocol = "udp"
    ports = ["8600", "8300-8302"] 
  }
  allow {
    protocol = "udp"
    ports    = ["4647"]
  }
  source_ranges = [ var.myip ]

}

## inbound SSH

resource "google_compute_firewall" "firewall-ssh" {
  name    = "firewall-ssh"
  network = google_compute_network.network.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = [ var.myip ]
#   destination_ranges = [ "34.116.68.195/32" ]
}

resource "google_compute_firewall" "internal-all" {
  name    = "internal-all"
  network = google_compute_network.network.name

  allow {
    protocol = "icmp"
  }
  allow {
    protocol = "tcp"
    ports = ["8500", "8600", "21000-21225", "8300-8302"] 
  }
  allow {
    protocol = "udp"
    ports = ["8600", "8300-8302"] 
  }

  allow {
    protocol = "tcp"
    ports    = ["4646", "4647", "4648"]
  }
  allow {
    protocol = "udp"
    ports    = ["4647"]
  }
  allow {
    protocol = "tcp"
    ports = ["22"]
  }

  source_ranges = [ var.internal_google_networks ]
#   destination_ranges = [ "34.116.68.195/32" ]
}

## Cloud NAT

resource "google_compute_router" "router" {
  name    = "burkey-router"
  network = google_compute_network.network.id

  bgp {
    asn = 64514
  }
}

resource "google_compute_router_nat" "nat" {
    router = google_compute_router.router.name
    name = "burkey-nat-router"
    nat_ip_allocate_option             = "AUTO_ONLY"
    source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES" 
  
}