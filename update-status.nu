let server_status_exit_code: number = (
  podman exec vintage-story-server /bin/bash -c 'pgrep dotnet' > /dev/null
  | complete
).exit_code;

let server_status: string = if $server_status_exit_code == 0 { 
  "alive"
} else {
  "dead"
}


let ip_addresses: list<string> = (
  ip addr
  | grep -Po '(?<=inet6\s).+(?=scope\sglobal)'
  | grep -Po '[a-zA-Z0-9:]{10,}'
  | split row "\n"
)

let result = {
  status: $server_status,
  ip: $ip_addresses,
  updatedAt: (date now | format date '%+')
}

echo $result

$result | save -f /tmp/status.json

gcloud storage cp /tmp/status.json gs://vintage-story-server-status
gcloud storage objects update gs://vintage-story-server-status/status.json --cache-control=max-age=600

rm /tmp/status.json