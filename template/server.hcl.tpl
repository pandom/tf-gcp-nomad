hostname=$(hostname)

#Generate config file
cat <<EOF > /etc/nomad.d/nomad.hcl
#NOMAD CONFIGURATION
bind_addr = "0.0.0.0"
advertise {
  http = "{{GetInterfaceIP \"ens4\"}}"
  rpc  = "{{GetInterfaceIP \"ens4\"}}"
  serf = "{{GetInterfaceIP \"ens4\"}}"
}
data_dir = "${nomad_data_dir}"
datacenter = "${dc_name}"
region = "${region}"
enable_syslog = "${syslog_enabled}"
syslog_facility = "${syslog_facility}"
log_level = "${syslog_log_level}"

server {
  enabled          = ${server_enabled}
  license_path = "${license_path}"
  bootstrap_expect = ${nomad_bootstrap_expect}
  authoritative_region = "${auth_region}"
  server_join {
    retry_join = ["${autojoin_tags}"]
    retry_max = 3
    retry_interval = "15s"
  }
}
consul {
  address = "${consul_server}"
  token   = "${consul_token}"
  namespace = "${consul_namespace}"
  auto_advertise      = true
  server_auto_join    = true
  client_auto_join    = true
}
acl {
  enabled = "${acl_enabled}"
  token_ttl = "300s"
  policy_ttl = "600s"
}
audit {
  enabled = "${audit_enabled}"
}

EOF

# Install the nomad as a service for systemd on linux
# IN PACKER IMAGE
cat <<EOF > /etc/consul.d/consul.hcl
data_dir  = "/tmp/"
log_level = "DEBUG"

datacenter = "DC"

server = true

bootstrap_expect = 1
ui               = true

bind_addr   = "0.0.0.0"
client_addr = "0.0.0.0"

ports {
  grpc = 8502
}

connect {
  enabled = true
}

advertise_addr                = "10.152.0.2"
enable_central_service_config = true
retry_join = ["${autojoin_tags_consul}"]
ui_config {
  enabled = true

EOF

sudo chown consul:consul /etc/consul.d/server.hcl
sudo chmod 664 /etc/systemd/system/consul.service
sudo systemctl daemon-reload
sudo systemctl enable consul
sudo systemctl start consul

# Finish service configuration for nomad and start the service
sudo chown nomad:nomad /etc/nomad.d/license.hclic
sudo chown nomad:nomad /etc/nomad.d/server.hcl
sudo chmod 664 /etc/systemd/system/nomad.service
sudo systemctl daemon-reload
sudo systemctl enable nomad
sudo systemctl start nomad