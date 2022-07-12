build {
    hcp_packer_registry {
    bucket_name = "nomad-ubuntu"
    description = <<EOT
Nomad Golden Images
    EOT
    bucket_labels = {
      "ubuntu" = "22.04",
      "golden"         = "true",
      "security_hardened" = "true",
      "cis_benchmarked" = "true",
      "nomad" = "true",
    }
    build_labels = {
        "log4j" = "resolved"
        "ciphers" = "2022-approved"
        "python-version"   = "3.9",
        "ubuntu-version" = "22.04"
        "build-time" = timestamp()
}
  }
  sources = [
		"googlecompute.nomad-server",
		#"googlecompute.nomad-client"
  ]

  provisioner "ansible" {
    playbook_file = "./playbook.yaml"
    user = "ubuntu"
    extra_arguments = [
			"--extra-vars",
			#"vault_addr=${var.vault_addr} ansible_user_password=${var.ansible_user_password}"
			"ansible_user_password=${var.ansible_user_password}"
		]
  }
}
