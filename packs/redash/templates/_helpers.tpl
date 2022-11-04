// allow nomad-pack to set the job name

[[- define "job_name" -]]
[[- if empty .redash.job_name  -]]
[[- .nomad_pack.pack.name | quote -]]
[[- else -]]
[[- .redash.job_name | quote -]]
[[- end -]]
[[- end -]]

[[- define "std_env" -]]
        REDASH_REDIS_URL="redis://redis:6379/0"
        REDASH_DATABASE_URL="postgresql://user:password@db.host/dbname"
        REDASH_SECRET_KEY="randomkey"
        REDASH_COOKIE_SECRET="randomkey2"
[[- end -]]