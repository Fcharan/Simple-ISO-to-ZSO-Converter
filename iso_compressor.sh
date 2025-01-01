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
  echo -e "${GREEN}1.${NC} Compress an ISO into ZSO"
  echo -e "${GREEN}2.${NC} Compress an ISO into CHD"
  echo -e "${GREEN}3.${NC} Exit"
  echo -e "${YELLOW}Please select an option (1-3):${NC}"
}

install_required_dependencies() {
  read -p "${YELLOW}The required dependencies for CHD creation are not installed. Do you want to install them? (y/n): ${NC}" choice
  if [[ "$choice" =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}Installing proot-distro...${NC}"
    pkg install proot-distro -y
    echo -e "${YELLOW}Installing Ubuntu distribution...${NC}"
    proot-distro install ubuntu
    echo -e "${YELLOW}Logging into Ubuntu...${NC}"
    proot-distro login ubuntu -- bash -c "
      echo -e '${YELLOW}Updating package list...${NC}' &&
      apt update &&
      echo -e '${YELLOW}Installing required packages...${NC}' &&
      apt install -y mame-tools unzip
    "
    echo -e "${GREEN}Dependencies installed successfully. Restarting script...${NC}"
    exec "$0"
  else
    echo -e "${RED}Dependencies not installed. Exiting...${NC}"
    exit 1
  fi
}

check_required_dependencies() {
  echo -e "${YELLOW}Checking if required packages are installed...${NC}"

  proot-distro login ubuntu -- bash -c "command -v chdman >/dev/null 2>&1 || { echo 'chdman not found'; exit 1; }"
  if [ $? -ne 0 ]; then
    install_required_dependencies
  fi
}

compress_iso() {
  if [ -f "$directory_file" ]; then
    echo -e "${YELLOW}Last used directories:${NC}"
    nl "$directory_file"
    read -p "Select a directory from the list or enter a new path (0 for new, any other key to cancel): " directory_choice

    if [ "$directory_choice" -eq 0 ]; then
      read -p "Enter the directory path to locate ISO files (e.g., /storage/emulated/0/iso/): " iso_directory
    elif [ -z "$directory_choice" ]; then
      return
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

  cd "$iso_directory" || { echo -e "${RED}Directory not found.${NC}"; return; }

  if [ -f "$directory_file" ]; then
    if ! grep -qx "$iso_directory" "$directory_file"; then
      sed -i "1i$iso_directory" "$directory_file"
    fi
  else
    echo "$iso_directory" > "$directory_file"
  fi

  tail -n "$max_history" "$directory_file" > "$directory_file.tmp" && mv "$directory_file.tmp" "$directory_file"

  echo -e "${YELLOW}Found ISO files:${NC}"
  select iso_file in *.iso; do
    if [ -n "$iso_file" ]; then
      echo -e "${GREEN}You selected: $iso_file${NC}"
      break
    else
      echo -e "${RED}Invalid selection.${NC}"
    fi
  done

  output_file="${iso_file%.iso}.zso"

  echo -e "${BLUE}Compressing '$iso_file' to '$output_file'...${NC}"
  python /data/data/com.termux/files/home/ziso.py -c 2 "$iso_file" "$output_file"

  echo -e "${GREEN}Compression complete.${NC}"

  read -p "Press Enter to return to the menu."
}

compress_iso_to_chd() {
  check_required_dependencies

  if [ -f "$directory_file" ]; then
    echo -e "${YELLOW}Last used directories:${NC}"
    nl "$directory_file"
    read -p "Select a directory from the list or enter a new path (0 for new, any other key to cancel): " directory_choice

    if [ "$directory_choice" -eq 0 ]; then
      read -p "Enter the directory path to locate ISO files for CHD (e.g., /storage/emulated/0/iso/): " iso_directory
    elif [ -z "$directory_choice" ]; then
      return
    else
      iso_directory=$(sed -n "${directory_choice}p" "$directory_file")
    fi

    if [ -z "$iso_directory" ]; then
      echo -e "${RED}Invalid selection.${NC}"
      return
    fi
  else
    read -p "Enter the directory path to locate ISO files for CHD (e.g., /storage/emulated/0/iso/): " iso_directory
  fi

  cd "$iso_directory" || { echo -e "${RED}Directory not found.${NC}"; return; }

  if [ -f "$directory_file" ]; then
    if ! grep -qx "$iso_directory" "$directory_file"; then
      sed -i "1i$iso_directory" "$directory_file"
    fi
  else
    echo "$iso_directory" > "$directory_file"
  fi

  tail -n "$max_history" "$directory_file" > "$directory_file.tmp" && mv "$directory_file.tmp" "$directory_file"

  echo -e "${YELLOW}Found ISO files for CHD:${NC}"
  select iso_file in *.iso; do
    if [ -n "$iso_file" ]; then
      echo -e "${GREEN}You selected: $iso_file${NC}"
      break
    else
      echo -e "${RED}Invalid selection.${NC}"
    fi
  done

  output_file="${iso_file%.iso}.chd"

  echo -e "${BLUE}Creating CHD from '$iso_file' to '$output_file'...${NC}"
  proot-distro login ubuntu -- chdman createcd -i "$iso_directory/$iso_file" -o "$iso_directory/$output_file"

  echo -e "${GREEN}CHD creation complete.${NC}"

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
      compress_iso_to_chd
      ;;
    3)
      echo -e "${RED}Exiting...${NC}"
      exit 0
      ;;
    *)
      echo -e "${RED}Invalid option, please try again.${NC}"
      ;;
  esac
done