Superset was successfully deployed with name [[ template "job_name" . ]] 
[[- if empty .superset.machine_name | not ]] on machine [[ quote .superset.machine_name ]] [[- end ]].
