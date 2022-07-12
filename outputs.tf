
output "Nomad_UI" {
    value = "http://${google_compute_forwarding_rule.default.ip_address}:4646"
  
}

output "Traefik_UI" {
    value = "http://${google_compute_forwarding_rule.traefik.ip_address}:8080"
  
}

# output "Fabio_Data" {
#     value = "${google_compute_forwarding_rule.fabio_data.ip_address}:9999"
  
# }
output "Bastion_IP" {
    value = google_compute_forwarding_rule.ssh.ip_address
  
}

output "Internal_Network" {
  value = data.google_compute_subnetwork.nomad.ip_cidr_range
}

## AMAZON OUTPUT

# output "aws-instance" {
#     value = module.ec2_nomad.public_ip
# }