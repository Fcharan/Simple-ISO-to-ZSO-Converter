#!/bin/bash

directory_file="$HOME/last_directories.txt"
max_history=5

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'

display_menu() {
  clear
  echo -e "${BLUE}ISO Compression Tool${NC}"
  echo -e "${BLUE}---------------------${NC}"
  echo -e "${GREEN}1.${NC} Compress an ISO"
  echo -e "${GREEN}2.${NC} Exit"
  echo -e "${YELLOW}Please select an option (1-2):${NC}"
}

compress_iso() {
  if [ -f "$directory_file" ]; then
    echo -e "${YELLOW}Last used directories:${NC}"
    nl "$directory_file"
    read -p "Select a directory from the list or enter a new path (0 for new): " directory_choice

    if [ "$directory_choice" -eq 0 ]; then
      read -p "Enter the directory path to locate ISO files (e.g., /storage/emulated/0/iso/): " iso_directory
    else
      iso_directory=$(sed -n "${directory_choice}p" "$directory_file")
    fi

    if [ -z "$iso_directory" ]; then
      echo -e "${RED}Invalid selection.${NC}"
      return
    fi
  else
    read -p "Enter the directory path to locate ISO files (e.g., /storage/emulated/0/iso/): " iso_directory
  fi

  cd "$iso_directory" || { echo -e "${RED}Directory not found.${NC}"; exit 1; }

  echo -e "${YELLOW}Found ISO files:${NC}"
  select iso_file in *.iso; do
    if [ -n "$iso_file" ]; then
      echo -e "${GREEN}You selected: $iso_file${NC}"
      break
    else
      echo -e "${RED}Invalid selection.${NC}"
    fi
  done

  read -p "Enter compression level (1-9, default: 2): " compression_level
  compression_level=${compression_level:-2}

  output_file="${iso_file%.iso}.zso"

  echo -e "${BLUE}Compressing '$iso_file' to '$output_file' with compression level $compression_level...${NC}"
  python /data/data/com.termux/files/home/ziso.py -c "$compression_level" "$iso_file" "$output_file"

  echo -e "${GREEN}Compression complete.${NC}"

  if [ -f "$directory_file" ]; then
    if ! grep -qx "$iso_directory" "$directory_file"; then
      sed -i "1i$iso_directory" "$directory_file"
    fi
  else
    echo "$iso_directory" > "$directory_file"
  fi

  tail -n "$max_history" "$directory_file" > "$directory_file.tmp" && mv "$directory_file.tmp" "$directory_file"

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
      echo -e "${RED}Exiting...${NC}"
      exit 0
      ;;
    *)
      echo -e "${RED}Invalid option, please try again.${NC}"
      ;;
  esac
done