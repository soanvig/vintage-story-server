#!/bin/sh

IP_ADDRESS=$()

podman exec vintage-story-server /bin/bash -c 'pgrep dotnet' > /dev/null

if [ $? -eq 0 ]; then
    echo 'Server status: alive'
else
    echo 'Server status: dead'
fi

for IP_ADDRESS in $(ip addr | grep -Po "(?<=inet6\s).+(?=scope\sglobal)")
do
    echo "IP address: $IP_ADDRESS"
done
