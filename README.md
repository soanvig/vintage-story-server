# vintage-story server

Wrapper around official vintage-story server. It is based on official dotnet base image, and is tagged the same way the official server is versioned.

Getting the server to run properly (especially: gracefully shutdown) is not straightforward in containerized environment, hence I decided to share image I created.
It properly shutdowns (waits for the server to gracefully shutdown) and is easy to operate. It also supplies a proper healthcheck.

Image repository: https://github.com/soanvig/vintage-story-server

## Podman or Docker

Podman and Docker commands are identical with small exceptions to `run` command (in most cases you can replace `podman` for `docker`).

I prefer Podman due to its daemon-less architecture, and non-root approach by default. The image is the same, the details about running it are different, and I listed them below.

## Start

Important points:
1. create a data directory, and mount it under `/home/vintagestory/data` - if you don't mount it, then you may lose your server's world
2. bind 42420 port
3. image creates non-root `vintagestory` user (id: 1000)
4. **For podman**: `--userns=keep-id` is required to have proper permissions to access data directory, and add `docker.io/` prefix to the image name
5. **For docker**: chown directory mounted in point 1. to user 1000:1000 (it is user running inside container): `chown -R 1000:1000 <data-directory-on-host-machine>` (it is necessary, because otherwise non-root user inside container won't have access to root-managed mounted volume).
6. **Always select image tag (server version)**, to avoid unexpected upgrades. By default docker/podman use `latest` tag meaning that recreating a container (which can happen unexpectedly) might download newer version than you were previously running.

Other configuration settings listed in commands below are arbitrary, and are just copied from my server configuration.

If it is your first time running a Vintage Story server please note, that by default server operates in whitelist mode, so you have to whitelist a player: `/player <player-name> whitelist on` (see [Operating](#operating) sections for running commands on the server).
Once whitelisted you might want to give admin privileges to your player to run server commands through Vintage Story directly: `/op <player-name>`.

### Podman (recommended)

```
podman run --stop-timeout 30 --replace -d --name vintage-story-server --userns=keep-id -v ~/vintage-story-server-data:/home/vintagestory/data -p 42420:42420 --restart always docker.io/soanvig/vintage-story-server:<VERSION-TAG>
```

(`--restart always` in podman is the same as `--restart unless-stopped` in docker)

### Docker

```
docker run --stop-timeout 30 -d --name vintage-story-server -v ~/vintage-story-server-data:/home/vintagestory/data -p 42420:42420 --restart unless-stopped soanvig/vintage-story-server:<VERSION-TAG>
```

## View logs

```
podman logs vintage-story-server
```

Note: logs are stored by the server inside `data/Logs/server-main.log`. This image simply follows that file, and prints its content to stdout (which makes container logs work).

## Operating

Once the container is up and running, you can:

1. run healthcheck: `podman healthcheck run vintage-story-sever` or `podman exec vintage-story-server healthcheck` (returns 0 status code for OK, 1 for a problem)
2. execute a command on the server: `podman exec vintage-story-server cmd <command>` (example: `podman exec vintage-story-server cmd /op PlayerName`) (reference official documentation for available commands)
