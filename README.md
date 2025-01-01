# A Simple Program That Converts ISO Into ZSO And CHD Inside Termux Application 

## Dependencies

• Python

• Lz4

• Ziso.py

• Mame-Tools

All Credits Goes To Respected Owners

## Features

• Automatically Downloads All Dependencies 

• Has An Simple Menu

## Installation

1 - Install [Termux](https://github.com/Fcharan/WinlatorMali/releases/download/0.0/termux-app_v0.118.1+github-debug_arm64-v8a.apk)

## Installation Command

Run the following command in your Termux:

<pre>
<code>
pkg install termux-am -y
termux-setup-storage
export DEBIAN_FRONTEND=noninteractive
echo 'DPkg::Options { "--force-confold"; }' | tee -a /data/data/com.termux/files/usr/etc/apt/apt.conf.d/local
pkg update -y && pkg upgrade -y --assume-yes && pkg install -y wget
wget https://raw.githubusercontent.com/Fcharan/Simple-ISO-to-ZSO-Converter/main/menu.sh
chmod +x menu.sh
./menu.sh
</code>
</pre>

This Command Will Guide You And Automatically Installs All Required Files

Use The Command "zso_menu" To Enter Start Menu Again After Exit

## Screenshot

![1000157069](https://github.com/user-attachments/assets/2bb183ba-74c2-4de7-a765-38bef18cefcd)

