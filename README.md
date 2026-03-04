#!/bin/bash

# ====================================================
# Ultimate VPS Banner Setup Script by Terry (TRONIC-B-21)
# Compact, Universal, Sticky Header, Dynamic Logo
# ====================================================

# 🛡 Ensure script runs as root
if [[ "$(id -u)" != "0" ]]; then
    echo -e "\033[1;31m[✘] Error: Please run this script as root.\033[0m"
    exit 1
fi

# -----------------------------
# 1️⃣ Disable default MOTD
# -----------------------------
sudo chmod -x /etc/update-motd.d/*
sudo rm -f /etc/motd
sudo touch /etc/motd
if grep -q "^PrintMotd" /etc/ssh/sshd_config; then
    sudo sed -i 's/^PrintMotd.*/PrintMotd no/' /etc/ssh/sshd_config
else
    echo "PrintMotd no" | sudo tee -a /etc/ssh/sshd_config
fi
sudo systemctl restart ssh

# -----------------------------
# 2️⃣ Install dependencies
# -----------------------------
echo -e "\033[1;33m[~] Installing required packages...\033[0m"
for pkg in figlet lolcat neofetch git curl; do
    if ! command -v $pkg &> /dev/null; then
        apt update -y
        apt install -y $pkg
    fi
done

# -----------------------------
# 3️⃣ Install extra figlet fonts
# -----------------------------
FIGLET_DIR="/usr/share/figlet"
if [ ! -d "$FIGLET_DIR" ]; then
    sudo mkdir -p "$FIGLET_DIR"
fi
if [ ! -f "$FIGLET_DIR/small.flf" ]; then
    git clone https://github.com/hIMEI29A/FigletFonts.git /tmp/FigletFonts
    sudo cp /tmp/FigletFonts/*.flf "$FIGLET_DIR/"
    rm -rf /tmp/FigletFonts
fi

# -----------------------------
# 4️⃣ Create banner script
# -----------------------------
echo -e "\033[1;32m[✔️] Creating banner script...\033[0m"
cat << 'EOF' > /etc/profile.d/hyper_lite.sh
#!/bin/bash
clear

# Function to show sticky header
show_hyper_header() {
    tput sc
    tput cup 0 0
    figlet -f small "Hyper Lite 2.5" 2>/dev/null | lolcat
    tput rc
}

# -----------------------------
# Show header once at login
# -----------------------------
show_hyper_header

# -----------------------------
# System Info
# -----------------------------
HOSTNAME=$(hostname)
IPADDR=$(hostname -I | awk '{print $1}')
CPU=$(awk -F ': ' '/model name/ {print $2; exit}' /proc/cpuinfo)
RAM=$(free -h | awk '/Mem:/ {print $2 " RAM"}')
UPTIME=$(uptime -p)
PACKAGES=$(dpkg -l 2>/dev/null | wc -l || echo "N/A")
SHELL=$(echo $SHELL)
TERM=$(echo $TERM)
RESOLUTION=$(xdpyinfo 2>/dev/null | awk '/dimensions:/ {print $2}' || echo "N/A")

# Show distro logo (optional)
if command -v neofetch &> /dev/null; then
    echo -e "\033[1;31m"
    neofetch --stdout --ascii_distro | lolcat
    echo -e "\033[0m"
fi

# Minimal info section
echo -e "\033[1;33m🔥 Ultimate VPS - Powered by TRONIC-B-21 🔥\033[0m"
echo -e "\033[1;31m============================================\033[0m"
echo -e "\033[1;34m• Hostname:\033[0m     $HOSTNAME"
echo -e "\033[1;34m• IP Address:\033[0m   $IPADDR"
echo -e "\033[1;34m• CPU:\033[0m          $CPU"
echo -e "\033[1;34m• Memory:\033[0m       $RAM"
echo -e "\033[1;34m• Uptime:\033[0m       $UPTIME"
echo -e "\033[1;34m• Packages:\033[0m     $PACKAGES"
echo -e "\033[1;34m• Shell:\033[0m        $SHELL"
echo -e "\033[1;34m• Terminal:\033[0m     $TERM"
echo -e "\033[1;34m• Resolution:\033[0m   $RESOLUTION"
echo -e "\033[1;36m• Motto:\033[0m        I Love Jesus"
echo -e "\033[1;31m============================================\033[0m"

# Sticky header on clear and prompts
alias clear='clear; show_hyper_header'
PROMPT_COMMAND='show_hyper_header'
EOF

chmod +x /etc/profile.d/hyper_lite.sh

# -----------------------------
# 5️⃣ Optional MOTD
# -----------------------------
echo -e "\033[1;32m[✔️] Writing MOTD...\033[0m"
cat << 'MOTD_EOF' > /etc/motd
$(figlet -f small "WELCOME" 2>/dev/null || echo "WELCOME")
🔥 Hyper Lite 2.5 - Ultimate VPS Installer by TRONIC-B-21 🔥
📖 Motto: I Love Jesus
⚙️  Auto System Info Display at Login
🔐 Unauthorized access is strictly prohibited
MOTD_EOF

echo -e "\033[1;32m[✔️] Hyper Lite 2.5 setup complete! Reconnect SSH to see the banner.\033[0m"
