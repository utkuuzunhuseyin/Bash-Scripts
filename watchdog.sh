#!/bin/bash

if [ "$EUID" -ne 0 ]; then
  echo "Please run this script with root privileges (sudo ./watchdog.sh <service_name>)"
  exit 1
fi

if [ $# -ne 1 ] || [ -z "$1" ]; then
  echo "Usage: $0 <service_name>"
  exit 1
fi

service_arg="$1"
log_file="/var/log/watchdog.log"
log_dir=$(dirname "$log_file")
timestamp=$(date +"%Y-%m-%d %H:%M:%S")

if [ ! -d "$log_dir" ]; then
  mkdir -p "$log_dir"
  if [ $? -ne 0 ]; then
      echo "Failed to create log directory at $log_dir. Please check permissions."
      exit 1
  fi
fi

if [ ! -f "$log_file" ]; then
  touch "$log_file"
  if [ $? -ne 0 ]; then
      echo "Failed to create log file at $log_file. Please check permissions."
      exit 1
  fi
fi

status=$(systemctl is-active "$service_arg")

if [ "$status" = "active" ]; then
  echo "$timestamp: $service_arg is active." >> "$log_file"
  exit 0
else
  echo "$timestamp: $service_arg is not active." >> "$log_file"
  echo "$timestamp: Attempting to restart $service_arg." >> "$log_file"
  systemctl restart "$service_arg"
  if [ $? -eq 0 ]; then
    echo "$timestamp: Successfully restarted $service_arg." >> "$log_file"
    exit 0
  else
    echo "$timestamp: Failed to restart $service_arg." >> "$log_file"
    exit 1
  fi
fi