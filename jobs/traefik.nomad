job "traefik" {
  datacenters = ["DC"]
  type        = "service"

  group "traefik" {
    count = 1

    network {
      port  "http"{
         static = 80
      }
      port  "admin"{
         static = 8080
      }
    }

    service {
      name = "traefik-http"
      provider = "nomad"
      port = "http"
      tags = [
        "traefik.http.routers.dashboard.rule=Host(`traefik.localhost`)",
        "traefik.http.routers.dashboard.service=api@internal",
        "traefik.http.routers.dashboard.entrypoints=web",
      ]
    }

    task "server" {
      driver = "docker"
      config {
        network_mode = "host"
        image = "traefik:2.8.1"
        ports = ["admin", "http"]
        args = [
          "--api.dashboard=true",
          "--api.insecure=true", ### For Test only, please do not use that in production
          "--entrypoints.web.address=:80",
          "--entrypoints.traefik.address=:8080",
          "--providers.nomad=true",
          "--providers.nomad.endpoint.address=http://127.0.0.1:4646" ### IP to your nomad server 
          #"--providers.nomad.endpoint.token=abc"
        ]
      }
    }
  }
}