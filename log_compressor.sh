#!/bin/bash

# ==============================================================================
# Script Name: log_compressor.sh
# Description: Scans a directory for .log files and compresses them using gzip.
# Author: Utku Uzunhüseyin / GitHub: utkuuzunhuseyin
# Date: 2026-01-16
# ==============================================================================

# ------------------------------------------------------------------------------
# Usage Guide:
# 1. Give execution permission: chmod +x log_compressor.sh
# 2. Run the script followed by the target directory path.
#
# Syntax:  ./log_compressor.sh <path_to_directory>
# Example: ./log_compressor.sh /var/log
# Example: ./log_compressor.sh /home/<username>/app_logs
# ------------------------------------------------------------------------------

# Get the directory path from the first argument provided by the user
LOG_DIR="$1"

# Check if the directory exists
if [ ! -d "$LOG_DIR" ]; then
  echo "Error: Directory not found: $LOG_DIR"
  exit 1
fi

echo "Starting compression in: $LOG_DIR"
echo "----------------------------------------"

# Loop through all .log files in the directory
for file in "$LOG_DIR"/*.log; do
  
  # Check if file exists (Handles empty directory case)
  [ -e "$file" ] || continue
  
  echo "Processing: $file" 
  
  # Compress the file (gzip automatically removes the original file)
  gzip "$file" 2>/dev/null

  # Get current timestamp for the log message
  timestamp=$(date '+%Y-%m-%d %H:%M:%S')

  # Check if the command was successful
  if [ $? -eq 0 ]; then
    echo "[$timestamp] Success: $file archived. Original replaced with $file.gz"
  else
    echo "[$timestamp] Error: Failed to archive $file."
  fi

  echo "----------------------------------------"
done