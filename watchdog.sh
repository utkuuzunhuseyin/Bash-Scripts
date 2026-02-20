#!/bin/bash

# ==============================================================================
# Script Name: watchdog.sh
# Description: Monitors a specified system service. If the service is inactive, 
#              it logs the failure and attempts to restart it automatically.
#              Requires root privileges to manage system services.
# Author: Utku Uzunhüseyin / GitHub: utkuuzunhuseyin
# Date: 2026-02-18
# ==============================================================================

# ------------------------------------------------------------------------------
# Usage Guide:
# 1. Give execution permission: chmod +x watchdog.sh
# 2. Run the script with root privileges followed by the service name.
#
# Syntax:  sudo ./watchdog.sh <service_name>
# Example: sudo ./watchdog.sh nginx
# Example: sudo ./watchdog.sh mysql
# ------------------------------------------------------------------------------

# Check for root privileges (Required for systemctl)
if [ "$EUID" -ne 0 ]; then
  echo "Error: Please run this script with root privileges."
  echo "Usage: sudo ./watchdog.sh <service_name>"
  exit 1
fi

# Check if the user provided the required argument
if [ $# -ne 1 ] || [ -z "$1" ]; then
  echo "Error: Please provide exactly one service name argument."
  echo "Usage: $0 <service_name>"
  exit 2
fi

# Assign arguments and define log variables
service_arg="$1"
log_file="/var/log/watchdog.log"
log_dir=$(dirname "$log_file")
timestamp=$(date +"%Y-%m-%d %H:%M:%S")

# Check if the log directory exists; create if missing
if [ ! -d "$log_dir" ]; then
  if ! mkdir -p "$log_dir"; then
      echo "Error: Failed to create log directory at $log_dir. Please check permissions."
      exit 3
  fi
fi

# Check if the log file exists; create if missing
if [ ! -f "$log_file" ]; then
  if ! touch "$log_file"; then
      echo "Error: Failed to create log file at $log_file. Please check permissions."
      exit 4
  fi
fi

# Check the status of the service
status=$(systemctl is-active "$service_arg")

if [ "$status" = "active" ]; then
  # Log success if service is running
  echo "[$timestamp] $service_arg is active." >> "$log_file"
  exit 0
else
  # Log failure and attempt restart if service is down
  echo "[$timestamp] Alert: $service_arg is not active." >> "$log_file"
  echo "[$timestamp] Action: Attempting to restart $service_arg..." >> "$log_file"

  # Check if the restart command was successful
  if systemctl restart "$service_arg"; then
    echo "[$timestamp] Success: Successfully restarted $service_arg." >> "$log_file"
    exit 0
  else
    echo "[$timestamp] Error: Failed to restart $service_arg." >> "$log_file"
    exit 5
  fi
fi