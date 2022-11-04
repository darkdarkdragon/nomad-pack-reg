// allow nomad-pack to set the job name

[[- define "job_name" -]]
[[- if empty .metabase.job_name  -]]
[[- .nomad_pack.pack.name | quote -]]
[[- else -]]
[[- .metabase.job_name | quote -]]
[[- end -]]
[[- end -]]
