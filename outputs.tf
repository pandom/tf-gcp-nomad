
output "Nomad_UI" {
    value = "http://${google_compute_forwarding_rule.default.ip_address}:4646"
  
}

output "Consul" {
    value = "http://${google_compute_forwarding_rule.consul.ip_address}:8500"
  
}

output "Fabio_UI" {
    value = "http://${google_compute_forwarding_rule.fabio_ui.ip_address}:9998"
  
}

output "Fabio_Data" {
    value = "${google_compute_forwarding_rule.fabio_data.ip_address}:9999"
  
}
output "Bastion_IP" {
    value = google_compute_forwarding_rule.ssh.ip_address
  
}

output "Internal_Network" {
  value = data.google_compute_subnetwork.nomad.ip_cidr_range
}
# output "server02" {
#     value = google_compute_address.server02.address
  
# }

# output "server03" {
#     value = google_compute_address.server03.address
  
# }