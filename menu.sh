#!/bin/bash

echo "Installing required packages..."
    pkg update -y && pkg upgrade -y
    pkg install python -y
    pkg install openssl
    pkg install clang
    python -m ensurepip --upgrade
    pip install lz4
    curl -fLo ziso.py https://github.com/Fcharan/Simple-ISO-to-ZSO-Converter/blob/main/ziso.py

echo "Downloading Script..."
wget https://github.com/Fcharan/Simple-ISO-to-ZSO-Converter/blob/main/iso_compressor.sh -O ~/iso_compressor.sh

chmod +x ~/iso_compressor.sh

echo  Use Command 'zso_menu'  Now
echo "alias zso_menu='bash ~/iso_compressor.sh'" >> ~/.bashrc

source ~/.bashrc
exec bash

echo Use Command 'zso_menu'  Now
if alias zso_menu &>/dev/null; then
    # Confirm that setup is complete
    echo "Simple ISO To ZSO Converter setup complete. You can now use the command 'zso_menu' to start it."
else
    echo "Failed to add alias for 'zso_menu'. Please check the script."
fi