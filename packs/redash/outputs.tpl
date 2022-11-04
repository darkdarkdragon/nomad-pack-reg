Redash was successfully deployed with name [[ template "job_name" . ]] 
[[- if empty .redash.machine_name | not ]] on machine [[ quote .redash.machine_name ]] [[- end ]].
