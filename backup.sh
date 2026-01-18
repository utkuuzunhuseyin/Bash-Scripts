#!/bin/bash

# ==============================================================================
# Script Name: backup.sh
# Description: Automates directory backup with logging and 7-day retention policy.
#              Creates a *.tar.gz archive of the source directory.
# Author: Utku Uzunhüseyin / GitHub: utkuuzunhuseyin
# Date: 2026-01-18
# ==============================================================================

# ------------------------------------------------------------------------------
# Usage Guide:
# 1. Give execution permission: chmod +x backup.sh
# 2. Run the script followed by source and destination directories.
#
# Syntax:  ./backup.sh <source_directory> <destination_directory>
# Example: ./backup.sh /var/www/html /home/ubuntu/backups
# ------------------------------------------------------------------------------

# Check if the user provided the required arguments
if [ $# -lt 2 ];then
  echo "Usage: $0 <source_directory> <destination_directory>"
  exit 1
fi

# Assign arguments to variables
source_directory="$1"
destination_directory="$2"

# Define timestamp and filenames
timestamp=$(date +"%Y%m%d_%H%M%S")
backup_name="backup_$timestamp.tar.gz"
final_archive_path="$destination_directory/$backup_name"
log_file="$destination_directory/backup_log.txt"

# Check if the source directory exists
if [ ! -d "$source_directory" ];then
    echo "Source directory does not exist: $source_directory"
    exit 2
fi

# Check for read permissions on source directory (Root check bypasses this)
if [ ! -r "$source_directory" ] && [ "$EUID" -ne 0 ]; then
    echo "Error: You don't have permission to read '$source_directory'. Try running with sudo."
    exit 3
fi

# Check if the destination directory exists; create if missing
if [ ! -d "$destination_directory" ]; then
    echo "Creating destination directory: $destination_directory"
    mkdir -p "$destination_directory"  
    if [ $? -ne 0 ]; then
        echo "Error: Failed to create destination directory '$destination_directory'. Check permissions."
        exit 4
    fi
fi

# Check for write permissions on destination directory (Root check bypasses this)
if [ ! -w "$destination_directory" ] && [ "$EUID" -ne 0 ]; then
    echo "Error: You don't have permission to write to '$destination_directory'. Try running with sudo."
    exit 5
fi

# Create the backup and log the process
echo "$(date '+%Y-%m-%d %H:%M:%S') - Creating backup of '$source_directory' at '$final_archive_path'..." >> "$log_file"
# Stderr (2>>) is redirected to the log file to capture any errors
tar -czf "$final_archive_path" "$source_directory" 2>> "$log_file" 

# Check if the backup command was successful
if [ $? -eq 0 ]; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Backup created successfully: $final_archive_path" >> "$log_file" 
    
    # Retention Policy: Delete backups older than 7 days
    find "$destination_directory" -name "backup_*.tar.gz" -mtime +7 -delete
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Old backups deleted." >> "$log_file"

else
    # Log the failure if the backup command failed
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Error: Backup creation failed." >> "$log_file"
    exit 6
fi


