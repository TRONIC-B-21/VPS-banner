#!/bin/bash

# Ultra VPS Banner Setup Script by Terry (TRONIC-B-21)

# 🛡 Ensure script runs as root
if [[ "$(id -u)" != "0" ]]; then
    echo -e "\033[1;31m[✘] Error: Please run this script as root.\033[0m"
    exit 1
fi

# 🧰 Install dependencies
echo -e "\033[1;33m[~] Installing required packages...\033[0m"
apt update -y && apt install -y figlet neofetch lolcat curl

# 🌐 Fetch latest banner.sh from GitHub
echo -e "\033[1;36m[⇩] Downloading latest banner script from GitHub...\033[0m"
curl -fsSL https://raw.githubusercontent.com/TRONIC-B-21/VPS-banner/main/banner.sh -o /etc/profile.d/banner.sh

# ✅ Make banner script executable
chmod +x /etc/profile.d/banner.sh
echo -e "\033[1;32m[✔️] Login banner installed and updated successfully.\033[0m"

# 📝 Set custom MOTD
echo -e "\033[1;32m[✔️] Writing Message of the Day (MOTD)...\033[0m"
cat << 'MOTD_EOF' > /etc/motd
$(figlet "WELCOME" | lolcat)
🔥 Hyper Lite 2.5 - Ultimate VPS Installer by TRONIC-B-21 🔥

📖 Motto: I Love Jesus
⚙️  Auto System Info Display at Login
🔐 Unauthorized access is strictly prohibited
MOTD_EOF

# ✅ Done
echo -e "\033[1;32m[✔️] Banner setup complete! Reconnect your terminal to enjoy the ultra banner.\033[0m"
