#!/bin/bash

tmux send-keys -t VS_SERVER.0 "$1" ENTER
echo "Command $1 sent"