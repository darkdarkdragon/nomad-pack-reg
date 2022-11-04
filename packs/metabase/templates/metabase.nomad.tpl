
job [[ template "job_name" . ]] {
  type = "service"
  datacenters = ["dc1"]

  [[- if empty .metabase.machine_name | not ]]
  constraint {
    attribute = "${node.unique.name}"
    value     = [[ quote .metabase.machine_name ]]
  }
  [[- end ]]

  meta {
    owner_user = "[[ env "USER" ]]"
    description = "metabase"
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
        to           = 3000
        static       = 80
      }
    }

    task "server" {
      driver = "docker"

      service {
        name = "metabase"
        port = "frontend"
      }

      resources {
          cpu = 30000
          memory = 16000
      }

      env {
        MB_DB_TYPE="postgres"
        MB_DB_DBNAME="metabase"
        MB_DB_PORT=5432
        MB_DB_USER="metabase"
        MB_DB_PASS="passowrd"
        MB_DB_HOST="db.host"
      }

      config {
        image = "metabase/metabase"

        labels {
          job = "${NOMAD_JOB_NAME}"
          group = "${NOMAD_GROUP_NAME}"
          scrape_logs = "true"
        }
      }
    }
  }
}
