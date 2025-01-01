#!/bin/bash

echo "Installing required packages..."
    pkg update -y && pkg upgrade -y
    pkg install python -y
    pkg install openssl
    pkg install clang
    python -m ensurepip --upgrade
    pip install lz4
    curl -fLo ziso.py https://raw.githubusercontent.com/Fcharan/Simple-ISO-to-ZSO-Converter/main/ziso.py

echo "Downloading Script..."
wget https://raw.githubusercontent.com/Fcharan/Simple-ISO-to-ZSO-Converter/main/iso_compressor.sh -O ~/iso_compressor.sh

chmod +x ~/iso_compressor.sh

echo  Use Command 'iso_menu'  Now
echo "alias iso_menu='bash ~/iso_compressor.sh'" >> ~/.bashrc

source ~/.bashrc
exec bash

echo Use Command 'iso_menu'  Now
if alias iso_menu &>/dev/null; then
    # Confirm that setup is complete
    echo "Simple ISO Compresser" setup complete. You can now use the command 'iso_menu' to start it."
else
    echo "Failed to add alias for 'iso_menu'. Please check the script."
fi