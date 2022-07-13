variable "project" {
    description = "Google Project ID from Doormat"
    type = string
    default = "hc-bbea0a79deed42a3b55f5fa4f13"
}

variable "region" {
  type = string
  default = "australia-southeast1"
}

variable "zone" {
  type = string
  default = "australia-southeast1-b"
}

variable "hcp_bucket" {
    type = string
    default = "nomad-ubuntu"
  
}

variable "hcp_channel" {
    type = string
    default = "deployment"
  
}

variable "gcn_name" {
    type = string
    default = "nomad"
}

variable "prefix" {
    type = string
    default = ""
}

variable "routing_mode" {
    type = string
    default = "REGIONAL"
  
}
variable "ssh_user_name" {
    type = string
    default = "ubuntu"
}
variable "ssh_pub_key" {
    type = string
    default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC8xYZMmdFegfk4NCog1casM50GMQOzunGt1gjO0TNLPI4aJvfwL3BDyEMmvzvkyLKlAxhuQ9nPjYW5X6BK1kihHIBgpz3lweaXJWE0ITJEGjLpniSBvvXsQQA/Dq7wIc/l383aEaiqYDzmUhcndBkCPcHPd7WyGTQJl76Oh+ot0gabQzy/qfXdZNCnAIyCrVV9ZVlZmvEVcPLWq2wtP3y/9m027GVTh01KxaZjVHvT5gvjsniN3ZI908HsSTTwHXykXQQCTIOTfKPVvpr3lSiFomzGKVLQU8bkRz86ICn5UlXUNlzgNQbRA/JBM2W+o8XbzYhyoL+srQ7upPuWkcRrYYNnCk6Ag9fnUXTFAjOJdKZdhrxF2AuM/uEp+M0JwSwsCgilnm5nztZfRf9QHgKuYAvelu4325TtazIPXUiwXAsIKCl0UyWI5YTRu3lO8P3fpG0HyMIG1y0MukTMUEP13kp3sqjif374JIKdThksjEetIYw2H9DU5WEVVXrHXUs= burkey@erebor.local"
  
}

variable "autojoin_tags" {
    default = "provider=gce project_name=hc-bbea0a79deed42a3b55f5fa4f13 tag_value=nomad-server"
  
}
variable "consul_autojoin_tags" {
    default = "provider=gce project_name=hc-bbea0a79deed42a3b55f5fa4f13 tag_value=consul-server"
  
}
variable "nvidia_node_type" {
  default = "nvidia-tesla-t4"
}
variable "node_type" {
  default = "e2-small"
}
variable "nomad_node" {
  default = "e2-small"
}

variable "nomad_version" {
    default = "1.3.0"
  
}

variable "name_nomadui" {
    default = "nomad"
}

variable "ubuntu" {
    default = "projects/ubuntu-os-cloud/global/images/ubuntu-2004-focal-v20210325"
  
}

variable "access" {
  default = false
}

variable "nvidia_enabled" {
  default = false
}

##Gary SSH config

variable "ssh_key_path" {
    default = "~/.ssh/id_rsa.pub"
     
}

variable "ssh_username" {
    default = "ubuntu"
}

variable "google_nomad_region" {
    default = "google"
}

## template flavor

variable "instance_size" {
    default = "e2-small"
  
}
# Burkey's address
variable "myip" {
    description = "my home IP address"
    default = "1.1.1.1/32"
    
  
}
##default google internal networks
variable "internal_google_networks" {
  default = "10.128.0.0/9"
}
# HashiCorp Tags

# variable "tags" {
#  tags = merge(var.tags, {
#      owner       = "go"
#    se-region   = "apj"
#    purpose     = "hcp connectivity"
#      ttl         = "-1"
#    terraform   = true
#    hc-internet-facing = false
#    })
# }
#Nomad template 

variable "license_path" {
    default = "/etc/nomad.d/license.hclic"
  
}

variable "nomad_bind_addr" {
    default = "0.0.0.0"
  
}

variable "nomad_data_dir" {
  default = "/opt/nomad/data/"
}

variable "consul_data_dir" {
  default = "/opt/consul/data/"
}

variable "dc_name" {
    default = "burkey"
}

variable "nomad_region" {
    default = "southeast"  
}
variable "nomad_datacenter" {
    default = "DC"
  
}

variable "nomad_auth_region" {
      default = "southeast"
}


variable "syslog_enabled" {
    default = true
  
}
variable "syslog_facility" {
    default = "LOCAL0"  
}

variable "syslog_log_level" {
    default = "INFO"  
}
variable "tls_disabled" {
    default = true
  
}

variable "nomad_server_status" {
    default = true  
}

variable "nomad_bootstrap_expect" {
    default = 3
}

variable "acl_enabled" {
    default = true
  
}

variable "audit_enabled" {
    default = true
  
}

variable "tls_key_path" {
    default = ""
}
variable "tls_cert_path" {
    default = ""
}
variable "ca_issuer_location" {
    default = ""
}

variable "min_nomad_server_replicas" {
  default = 3
}
variable "max_nomad_server_replicas" {
    default = 5  
}

variable "min_nomad_client_replicas" {
  default = 2
}
variable "max_nomad_client_replicas" {
    default = 10  
}

variable "min_nomad_nvidia_client_replicas" {
  default = 2
}
variable "max_nomad_nvidia_client_replicas" {
    default = 2  
}

#variables

variable "consul_server" {
  default = "consul-cluster.consul.11eb5471-19a8-952e-885d-0242ac110009.aws.hashicorp.cloud"
}

variable "consul_token" {
  default = ""
}
variable "consul_namespace" {
    default = "default"
  
}
variable "nomad_ui_enabled" {
  default = true
  type = string
}
variable "nomad_vault_url" {
  type = string
  default = "https://vault-plus.vault.11eb5471-19a8-952e-885d-0242ac110009.aws.hashicorp.cloud:8200"
}