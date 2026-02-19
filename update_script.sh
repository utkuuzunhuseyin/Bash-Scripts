#!/bin/bash

log_file="./updater.log"
error_log="./updater_errors.log"
timestamp=$(date +"%Y-%m-%d %H:%M:%S")

if [ "$EUID" -ne 0 ]; then
  echo "Error: Please run this script as root or using sudo"
  echo "Usage: sudo ./update_script.sh"
  exit 1 
fi

[ -f /etc/os-release ] && . /etc/os-release || { echo "Error: Could not source os-release file"; exit 2; }

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

end_timestamp=$(date +"%Y-%m-%d %H:%M:%S")

if [ $? -eq 0 ]; then
    echo "[$end_timestamp] Update completed successfully!"
    echo "Check $log_file for details."
else
    echo "[$end_timestamp] Update failed with errors!"
    echo "Check $error_log for details."
fi