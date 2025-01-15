FROM mcr.microsoft.com/dotnet/runtime:7.0
EXPOSE 42420

RUN apt update
# screen and pgrep required by server.sh
RUN apt install -y procps screen

RUN useradd vintagestory -s /sbin/nologin && mkdir -p /home/vintagestory/server && mkdir /home/vintagestory/data

WORKDIR /home/vintagestory/server
ADD https://cdn.vintagestory.at/gamefiles/unstable/vs_server_linux-x64_1.20.0-rc.9.tar.gz vs_server.tar.gz
RUN tar xf vs_server.tar.gz && rm vs_server.tar.gz

# Patch server.sh DATAPATH
RUN sed -i "s|/var/vintagestory/data|/home/vintagestory/data|" /home/vintagestory/server/server.sh 
RUN chmod +x server.sh

ENTRYPOINT exec dotnet VintagestoryServer.dll --dataPath "/home/vintagestory/data"