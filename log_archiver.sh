#!/bin/bash

# ==============================================================================
# Script Name: log_archiver
# Description: Compresses .log files in a specific directory into .tar.gz archives 
#              and removes the original files to save disk space.
# Author: [Utku Uzunhüseyin/GitHub: utkuuzunhuseyin]
# Date: 2026-01-15
# ==============================================================================

# Directory containing the log files
# TODO: Update this path to your actual log directory
LOG_DIR="/home/ubuntu/log_records"

# Check if the directory exists
if [ ! -d "$LOG_DIR" ]; then
  echo "Error: Directory $LOG_DIR does not exist."
  exit 1
fi

echo "Starting log archival process in: $LOG_DIR"
echo "----------------------------------------"

# Iterate through all .log files in the directory
for file in "$LOG_DIR"/*.log; do
  
  # Check if file actually exists (handles cases with no matching files)
  [ -e "$file" ] || continue

  echo "Archiving: $file"

  # Compress the file using tar
  # -c: create archive, -z: compress with gzip, -f: filename
  tar -czf "${file}.tar.gz" "$file" 2>/dev/null

  # Check the exit status of the tar command
  if [ $? -eq 0 ]; then
    # If successful, remove the original .log file
    rm "$file"
    echo "Success: $file archived and original deleted."
  else
    # If failed, keep the original file
    echo "Error: Failed to archive $file. Original file kept."
  fi

  echo "-----------------------------"
done

echo "Operation completed!"