#!/bin/bash

cmd /stats > /dev/null
sleep 0.1
{ tail -n 25 ../data/Logs/server-main.log | grep "Handling Console Command /stats"; } > /dev/null 2>&1

exit $?