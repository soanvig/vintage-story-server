FROM mcr.microsoft.com/dotnet/runtime:7.0
EXPOSE 42420

RUN apt -y update && apt -y install procps

RUN useradd vintagestory -m -s /sbin/nologin

USER vintagestory

RUN mkdir /home/vintagestory/server /home/vintagestory/data

RUN ls -l /home/vintagestory

WORKDIR /home/vintagestory/server
ADD --chown=vintagestory:vintagestory https://cdn.vintagestory.at/gamefiles/unstable/vs_server_linux-x64_1.20.0-rc.9.tar.gz vs_server.tar.gz
RUN tar xf vs_server.tar.gz && rm vs_server.tar.gz

ENTRYPOINT exec dotnet VintagestoryServer.dll --dataPath "/home/vintagestory/data"