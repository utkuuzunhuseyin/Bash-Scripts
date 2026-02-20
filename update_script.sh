#!/bin/bash

# ==============================================================================
# Script Name: update_script.sh
# Description: Detects the Linux distribution and automatically runs the 
#              appropriate system update/upgrade commands. Logs the process 
#              and any errors. Requires root privileges.
# Author: Utku Uzunhüseyin / GitHub: utkuuzunhuseyin
# Date: 2026-02-19
# ==============================================================================

# ------------------------------------------------------------------------------
# Usage Guide:
# 1. Give execution permission: chmod +x update_script.sh
# 2. Run the script with root privileges.
#
# Note: The script automatically detects your Linux distribution (Ubuntu, CentOS,
#       Debian, etc.) and runs the appropriate commands. You do not need to 
#       provide any arguments; just execute it with root privileges.
#
# Syntax:  sudo ./update_script.sh
# Example: sudo ./update_script.sh
# ------------------------------------------------------------------------------

# Define log files and current timestamp
log_file="./updater.log"
error_log="./updater_errors.log"
timestamp=$(date +"%Y-%m-%d %H:%M:%S")

# Check for root privileges (Required for system updates)
if [ "$EUID" -ne 0 ]; then
  echo "Error: Please run this script as root or using sudo"
  echo "Usage: sudo ./update_script.sh"
  exit 1 
fi

# Source the os-release file to detect the Linux distribution
if [ -f /etc/os-release ]; then
  . /etc/os-release
else
  echo "Error: Could not source os-release file"
  exit 2
fi

# Execute package manager update/upgrade commands based on the detected OS
case "$ID" in
    ubuntu|debian|kali)
        echo "[$timestamp] Detected Linux distribution: $ID. Starting update process..." >> $log_file
        apt-get update && apt-get dist-upgrade -y 1>> $log_file 2>> $error_log
        ;;
    centos|rhel|fedora|almalinux|rocky)
        echo "[$timestamp] Detected Linux distribution: $ID. Starting update process..." >> $log_file
        dnf upgrade --refresh -y 1>> $log_file 2>> $error_log
        ;;
    amzn)
        echo "[$timestamp] Detected Linux distribution: $ID. Starting update process..." >> $log_file
        yum update -y 1>> $log_file 2>> $error_log
        ;;
    sles|opensuse|suse)
        echo "[$timestamp] Detected Linux distribution: $ID. Starting update process..." >> $log_file
        zypper refresh && zypper update -y 1>> $log_file 2>> $error_log
        ;;  
    *)
        echo "[$timestamp] Unsupported Linux distribution: $ID. Please use a supported distribution."
        echo "[$timestamp] Unsupported distribution: $ID" >> $error_log
        exit 3
        ;;
esac

update_status=$?

# Define timestamp for the end of the process
end_timestamp=$(date +"%Y-%m-%d %H:%M:%S")

# Check if the update process was successful and output the result
if [ $update_status -eq 0 ]; then
    echo "[$end_timestamp] Update completed successfully!"
    echo "Check $log_file for details."
else
    echo "[$end_timestamp] Update failed with errors!"
    echo "Check $error_log for details."
fi