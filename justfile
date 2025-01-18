default:
  just --list

# --format docker is required by HEALTHCHECK in containerfile
build:
  podman build --format docker -t vintage-story-server .

start: build
  podman run --replace --name vintage-story-server -p 42420:42420 vintage-story-server

# Requires: podman system connection add --identity ~/.ssh/id_rsa vps ssh://mortimer@192.168.1.106:22
# Also `--userns=keep-id` gives new user inside container access to mounted volume
deploy-vps: build
  podman image scp vintage-story-server vps::
  ssh vps 'podman run --stop-timeout 30 --replace -d --name vintage-story-server --userns=keep-id -v ~/vintage-story-server-data:/home/vintagestory/data -p 42420:42420 --restart always localhost/vintage-story-server'