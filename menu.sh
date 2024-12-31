#!/bin/bash

install_dependencies() {
  if ! command -v python &>/dev/null; then
    pkg install python -y
  fi

  if ! command -v pip &>/dev/null; then
    python -m ensurepip --upgrade
  fi

  if ! pip show lz4 &>/dev/null; then
    pip install lz4
  fi

  if [ ! -f "ziso.py" ]; then
    curl -fLo ziso.py https://github.com/Fcharan/Simple-ISO-to-ZSO-Converter/blob/main/ziso.py
    if [ $? -ne 0 ]; then
      exit 1
    fi
  fi
}

download_script() {
  curl -fLo iso_compressor.sh https://github.com/Fcharan/Simple-ISO-to-ZSO-Converter/blob/main/iso_compressor.sh
  if [ $? -ne 0 ]; then
    exit 1
  fi
}

create_shortcut() {
  echo '#!/bin/bash' > ~/ziso_menu
  echo 'cd /data/data/com.termux/files/home && ./iso_compressor.sh' >> ~/ziso_menu
  chmod +x ~/ziso_menu
}

make_executable() {
  chmod +x iso_compressor.sh
}

install_dependencies
download_script
make_executable
create_shortcut

echo "Installation complete!"
echo "You can now run the menu by typing 'ziso_menu' in your terminal."