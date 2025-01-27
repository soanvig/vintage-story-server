FROM mcr.microsoft.com/dotnet/runtime:7.0

RUN apt -y update && apt -y install procps tmux

RUN useradd vintagestory -m -s /sbin/nologin

COPY ./launch.bash /usr/bin/launch
COPY ./cmd.bash /usr/bin/cmd
COPY ./healthcheck.bash /usr/bin/healthcheck

USER vintagestory

RUN mkdir /home/vintagestory/server /home/vintagestory/data

WORKDIR /home/vintagestory/server
ADD --chown=vintagestory:vintagestory https://cdn.vintagestory.at/gamefiles/stable/vs_server_linux-x64_1.20.2.tar.gz vs_server.tar.gz
RUN tar xf vs_server.tar.gz && rm vs_server.tar.gz

EXPOSE 42420

HEALTHCHECK --interval=10s --retries=10 \
  CMD healthcheck

ENTRYPOINT exec launch
