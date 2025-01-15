default:
  just --list

build:
  podman build -t vintage-story-server .

start:
  podman run --replace -it --name vintage-story-server -p 42420:42420 vintage-story-server

# Requires: podman system connection add --identity ~/.ssh/id_rsa vps ssh://mortimer@192.168.1.106:22
# -it in podman run is crucial because server receives commands from stdin
# After that we have to do `podman attach vintage-story-server`, send commands, and quit with after we are done with CTRL+P+Q 
deploy-vps: build
  podman image scp vintage-story-server vps::
  ssh vps 'podman run --stop-timeout 30 --replace -it -d --name vintage-story-server -v ~/vintage-story-server-data:/home/vintagestory/data -p 42420:42420 --restart always localhost/vintage-story-server'\