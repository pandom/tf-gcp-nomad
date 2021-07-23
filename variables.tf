variable "region" {
    default = "australia-southeast1-b"

}
variable "zoneb" {
    default = "australia-southeast1-b"

}
variable "project" {
    default = "burkey-gcp-demos-317523"
  
}

variable "node_type" {
  default = "e2-small"
}
variable "nomad_node" {
  default = "e2-small"
}

variable "nomad_version" {
    default = "1.0.4"
  
}

variable "portname_nomadui" {
    default = "nomadui"
}

variable "ubuntu" {
    default = "projects/ubuntu-os-cloud/global/images/ubuntu-2004-focal-v20210325"
  
}

variable "access" {
  default = false
}

##Gary SSH config

variable "ssh_key_path" {
    default = "~/.ssh/id_rsa.pub"
     
}

variable "ssh_username" {
    default = "ubuntu"
}

## template flavor

variable "instance_size" {
    default = "e2-small"
  
}
# Burkey's address
variable "myip" {
    default = "120.158.180.52/32"
  
}
##default google internal networks
variable "internal_google_networks" {
  default = "10.128.0.0/9"
}

#Nomad template 
variable "autojoin_tags" {
    default = "provider=gce project_name=burkey-gcp-demos-317523 tag_value=nomad-server"
  
}
variable "autojoin_tags" {
    default = "provider=gce project_name=burkey-gcp-demos-317523 tag_value=consul-server"
  
}
variable "license_path_consul" {
    default = "/etc/consul.d/license.hclic"
  
}
variable "license_path" {
    default = "/etc/nomad.d/license.hclic"
  
}

variable "nomad_bind_addr" {
    default = "0.0.0.0"
  
}

variable "nomad_data_dir" {
  default = "/opt/nomad/data/"
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