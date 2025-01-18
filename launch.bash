#!/bin/bash

keep_alive() {
  while true; do 
    pgrep dotnet > /dev/null 2>&1

    if [ $? -eq 1 ]; then
        break
    fi

    sleep 1
  done;
}

wait_for_server_close() {
  while true; do 
    pgrep dotnet > /dev/null 2>&1

    if [ $? -eq 1 ]; then
        break
    fi

    echo "Waiting for server to terminate"
    sleep 1
  done;
}

wait_for_server_start() {
  counter=0

  # Overall waiting time is 50 * 3s = 150s
  max_count=50
  sleep_time=3

  while true; do 
    
    if [ -f "../data/Logs/server-main.log" ]; then
      break
    fi

    if [[ "$counter" -gt "$max_count" ]]; then
      echo "Cannot start server. If any logs are available they will be printed below"
      tmux capture-pane -S - -pt --
      exit 1
    fi

    echo "Waiting for server to start..."
    counter=$((counter+1))
    sleep $sleep_time
  done;
}

terminate_term() { 
  cmd /stop > /dev/null

  echo "Received SIGTERM"
  echo "Waiting for server to terminate"
}

terminate_int() { 
  cmd /stop > /dev/null

  echo "Received SIGINT"
  echo "Waiting for server to terminate"
}

trap terminate_term TERM
trap terminate_int INT

# sleep 30 is used to keep tmux session open if server cannot start, so we have time to capture logs
tmux new -d -s VS_SERVER 'dotnet VintagestoryServer.dll --dataPath "/home/vintagestory/data" && sleep 30'

wait_for_server_start

tail -F ../data/Logs/server-main.log &

keep_alive
