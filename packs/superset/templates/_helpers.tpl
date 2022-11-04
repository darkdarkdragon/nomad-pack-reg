// allow nomad-pack to set the job name

[[- define "job_name" -]]
[[- if empty .superset.job_name  -]]
[[- .nomad_pack.pack.name | quote -]]
[[- else -]]
[[- .superset.job_name | quote -]]
[[- end -]]
[[- end -]]
