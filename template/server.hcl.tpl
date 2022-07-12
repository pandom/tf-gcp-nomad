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
ui {
  enabled = ${nomad_ui_enabled}
  vault {
    ui_url = "${nomad_vault_url}"
  }
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

acl {
  enabled = "${acl_enabled}"
  token_ttl = "300s"
  policy_ttl = "600s"
}
audit {
  enabled = "${audit_enabled}"
}
telemetry {
 collection_interval = "5s",
 publish_allocation_metrics = true,
 publish_node_metrics = true,
 prometheus_metrics = true
}

EOF



# Finish service configuration for nomad and start the service
sudo chown nomad:nomad /etc/nomad.d/license.hclic
sudo chown nomad:nomad /etc/nomad.d/server.hcl
sudo chmod 664 /etc/systemd/system/nomad.service
sudo systemctl daemon-reload
sudo systemctl enable nomad
sudo systemctl start nomad