Metabase was successfully deployed with name [[ template "job_name" . ]] 
[[- if empty .metabase.machine_name | not ]] on machine [[ quote .metabase.machine_name ]] [[- end ]].
