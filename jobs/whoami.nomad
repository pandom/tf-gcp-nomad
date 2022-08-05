job "whoami" {
  datacenters = ["DC"]

  type = "service"

  group "demo" {
    count = 5

    network {
       port "http" {
         to = 3000
       }
    }

    service {
      name = "whoami-demo"
      port = "http"
      provider = "nomad"

      tags = [
        "traefik.enable=true",
        "traefik.http.routers.http.rule=Host(`whoami.nomad.localhost`)",
        "traefik.http.routers.http.rule=Path(`/whoami`)",
      ]
    }

    task "server" {
      env {
        WHOAMI_PORT_NUMBER = "${NOMAD_PORT_http}"
      }

      driver = "docker"

      config {
        image = "traefik/whoami"
        ports = ["http"]
      }
    }
  }
}