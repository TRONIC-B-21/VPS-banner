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

# 🧾 Create Banner Script
echo -e "\033[1;32m[✔️] Creating login banner...\033[0m"
cat << 'EOF' > /etc/profile.d/banner.sh
#!/bin/bash
clear

# Collect system info
HOSTNAME=$(hostname)
IPADDR=$(hostname -I | awk '{print $1}')
CPU=$(awk -F ': ' '/model name/ {print $2; exit}' /proc/cpuinfo)
RAM=$(free -h | awk '/Mem:/ {print $2 " RAM"}')
UPTIME=$(uptime -p)

# Display banner
echo -e "\033[1;35m"
figlet -f slant "Hyper Lite 2.5" | lolcat
echo -e "\033[0m"

echo -e "\033[1;33m🔥 Ultimate VPS - Powered by TRONIC-B-21 🔥\033[0m"
echo -e "\033[1;31m============================================\033[0m"
echo -e "\033[1;34m• Hostname:\033[0m     $HOSTNAME"
echo -e "\033[1;34m• IP Address:\033[0m   $IPADDR"
echo -e "\033[1;34m• CPU:\033[0m          $CPU"
echo -e "\033[1;34m• Memory:\033[0m       $RAM"
echo -e "\033[1;34m• Uptime:\033[0m       $UPTIME"
echo -e "\033[1;36m• Motto:\033[0m        I Love Jesus"
echo -e "\033[1;31m============================================\033[0m"

neofetch --disable resolution wm theme | lolcat
EOF

# ✅ Make it executable
chmod +x /etc/profile.d/banner.sh

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
