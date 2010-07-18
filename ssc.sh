#!/bin/bash
#
# Simulates a slow connection with delay, like a mobile connection.
#
# Uses ipfw to set up bandwidth-rules.
# Should be run with sudo.
#

BANDWIDTH="1Mbit/s";
DELAY="250ms";

if [ $# -ne 1 ]; then
  echo "Usage: sudo $0 command";
  echo "Commands:";
  echo "start - Start simulation.";
  echo "stop  - Stop simulation.";
  exit;
else
  if [ $1 = "start" ]; then
    echo "|- Starting simulation.";
    echo "|- Bandwidth: $BANDWIDTH";
    echo "|- Delay: $DELAY";
    ipfw add 100 pipe 1 ip from any to any out
    ipfw add 110 pipe 2 ip from any to any in
    ipfw pipe 1 config delay $DELAY bw $BANDWIDTH
    ipfw pipe 2 config delay $DELAY bw $BANDWIDTH
    exit;
  fi

  if [ $1 = 'stop' ]; then
    echo "|- Stoping simulation.";
    ipfw delete 100
    ipfw delete 110
    exit;
  fi

  echo "$0: Unknown command '$1'";
fi