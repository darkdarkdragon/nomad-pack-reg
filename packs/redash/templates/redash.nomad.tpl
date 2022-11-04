
job [[ template "job_name" . ]] {
  type = "service"
  datacenters = ["dc1"]

  [[- if empty .redash.machine_name | not ]]
  constraint {
    attribute = "${node.unique.name}"
    value     = [[ quote .redash.machine_name ]]
  }
  [[- end ]]

  meta {
    owner_user = "[[ env "USER" ]]"
    description = "redash"
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
        to           = 5000
        static       = 80
      }
    }

    task "server" {
      driver = "docker"

      service {
        name = "redash"
        port = "frontend"
      }

      resources {
          cpu = 10000
          memory = 16000
      }

      env {
        [[ template "std_env" ]]
        REDASH_WEB_WORKERS="4"
      }

      config {
        image = "redash/redash"
        command = "server"

        labels {
          job = "${NOMAD_JOB_NAME}"
          group = "${NOMAD_GROUP_NAME}"
          scrape_logs = "true"
        }
      }
    }
    task "scheduler" {
      driver = "docker"
      resources {
          cpu = 2000
          memory = 8000
      }
      env {
        [[ template "std_env" ]]
        QUEUES="celery"
        WORKERS_COUNT=1
      }
      config {
        image = "redash/redash"
        command = "scheduler"
        labels {
          job = "${NOMAD_JOB_NAME}"
          group = "${NOMAD_GROUP_NAME}"
          scrape_logs = "true"
        }
      }
    }
    task "scheduled_worker" {
      driver = "docker"
      resources {
          cpu = 2000
          memory = 8000
      }
      env {
        [[ template "std_env" ]]
        WORKERS_COUNT=1
        QUEUES="scheduled_queries,schemas"
      }
      config {
        image = "redash/redash"
        command = "worker"
        labels {
          job = "${NOMAD_JOB_NAME}"
          group = "${NOMAD_GROUP_NAME}"
          scrape_logs = "true"
        }
      }
    }
    task "adhoc_worker" {
      driver = "docker"
      resources {
          cpu = 2000
          memory = 8000
      }
      env {
        [[ template "std_env" ]]
        WORKERS_COUNT=1
        QUEUES="queries"
      }
      config {
        image = "redash/redash"
        command = "worker"
        labels {
          job = "${NOMAD_JOB_NAME}"
          group = "${NOMAD_GROUP_NAME}"
          scrape_logs = "true"
        }
      }
    }
  }
}
