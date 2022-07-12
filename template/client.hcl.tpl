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

client {
  enabled = ${server_enabled}
  server_join {
    retry_join = ["${autojoin_tags}"]
    retry_max = 3
    retry_interval = "15s"
  }
}
telemetry {
 collection_interval = "5s",
 publish_allocation_metrics = true,
 publish_node_metrics = true,
 prometheus_metrics = true
}
plugin "nvidia-gpu" {
  config {
    enabled            = ${nvidia_enabled}
    ignored_gpu_ids    = ["GPU-fef8089b", "GPU-ac81e44d"]
    fingerprint_period = "1m"
  }
}
EOF



# Install the consul as a service for systemd on linux
# IN PACKER IMAGE

# Finish service configuration for nomad and start the service
sudo chown nomad:nomad /etc/nomad.d/server.hcl
sudo chmod 664 /etc/systemd/system/nomad.service
sudo systemctl daemon-reload
sudo systemctl enable nomad
sudo systemctl start nomad