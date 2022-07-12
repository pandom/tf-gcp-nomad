#Nomad Service Account

resource "random_string" "nomad" {
    upper = false
    special = false
    numeric = false
    length = 16
}

resource "google_service_account" "nomad_node" {
    account_id = random_string.nomad.result
    display_name = local.nomad_node_server_name
    
}


resource "google_project_iam_member" "nomad-nodes" {
  project =  var.project
  role = "roles/compute.instanceAdmin"
  member = "serviceAccount:${google_service_account.nomad_node.email}"
}

