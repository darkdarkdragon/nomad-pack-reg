
job [[ template "job_name" . ]] {
  type = "service"
  datacenters = ["dc1"]

  [[- if empty .superset.machine_name | not ]]
  constraint {
    attribute = "${node.unique.name}"
    value     = [[ quote .superset.machine_name ]]
  }
  [[- end ]]

  meta {
    owner_user = "[[ env "USER" ]]"
    description = "Superset"
    // nomad-pack doesn't show verions from metadata.hcl if pack is deployed from local folder, so we maintain own pack version here
    version = "1"
  }

  group "main" {
    count = 1

    network {
      mode = "bridge"
      dns {
        servers = ["100.100.100.100"]
      }
      port "frontend" {
        host_network = "internal"
        to           = 8088
        static       = 9090
      }
    }

    task "execution" {
      driver = "docker"

      service {
        name = "superset"
        port = "frontend"
      }

      resources {
          cpu = 10000
          memory = 16000
      }

      template {
        destination = "secrets/secret.env"
        env         = true
        data        = <<EOH
        DOCKER_USER=user
        DOCKER_PASS=pass
        EOH
      }

      config {
        image = "superset"

        auth {
            username = "${DOCKER_USER}"
            password = "${DOCKER_PASS}"
        }

        labels {
          job = "${NOMAD_JOB_NAME}"
          group = "${NOMAD_GROUP_NAME}"
          scrape_logs = "true"
        }
      }
    }
  }
}
