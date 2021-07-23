build {
  sources = [
		"googlecompute.nomad-server",
		"googlecompute.nomad-client"
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
