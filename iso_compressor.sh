#!/bin/bash

display_menu() {
  clear
  echo "ISO Compression Tool"
  echo "---------------------"
  echo "1. Compress an ISO"
  echo "2. Exit"
  echo "Please select an option (1-2):"
}

compress_iso() {
  read -p "Enter the directory path to locate ISO files (e.g., /storage/emulated/0/iso/): " iso_directory
  cd "$iso_directory" || { echo "Directory not found."; exit 1; }

  echo "Found ISO files:"
  select iso_file in *.iso; do
    if [ -n "$iso_file" ]; then
      echo "You selected: $iso_file"
      break
    else
      echo "Invalid selection."
    fi
  done

  read -p "Enter compression level (1-9, default: 2): " compression_level
  compression_level=${compression_level:-2}

  echo "Compressing '$iso_file' to '$iso_file.zso' with compression level $compression_level..."
  python /data/data/com.termux/files/home/ziso.py -c "$compression_level" "$iso_file" "$iso_file.zso"

  echo "Compression complete."
  read -p "Press Enter to return to the menu."
}

while true; do
  display_menu
  read -p "Select option: " option

  case $option in
    1)
      compress_iso
      ;;
    2)
      echo "Exiting..."
      exit 0
      ;;
    *)
      echo "Invalid option, please try again."
      ;;
  esac
done