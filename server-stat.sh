#!/bin/bash

# server-stats.sh - Script untuk menganalisis statistik performa server
echo "=== Server Performance Statistics ==="
echo "Report generated on: $(date)"
echo "----------------------------------------"

# CPU Usage
echo -e "\n=== CPU Usage ==="
cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}')
echo "Total CPU Usage: $cpu_usage%"

# Memory Usage
echo -e "\n=== Memory Usage ==="
free -m | grep "Mem:" | awk '{
    total=$2;
    used=$3;
    free=$4;
    printf "Total Memory: %d MB\n", total;
    printf "Used Memory: %d MB (%.2f%%)\n", used, (used/total*100);
    printf "Free Memory: %d MB (%.2f%%)\n", free, (free/total*100);
}'

# Disk Usage
echo -e "\n=== Disk Usage ==="
df -h / | tail -n 1 | awk '{
    printf "Total Disk Space: %s\n", $2;
    printf "Used Space: %s (%s)\n", $3, $5;
    printf "Free Space: %s\n", $4;
}'

# Top 5 CPU-consuming processes
echo -e "\n=== Top 5 Processes by CPU Usage ==="
ps aux --sort=-%cpu | head -6 | awk 'NR>1 {printf "%s\t%.1f%%\t%s\n", $11, $3, $2}'

# Top 5 Memory-consuming processes
echo -e "\n=== Top 5 Processes by Memory Usage ==="
ps aux --sort=-%mem | head -6 | awk 'NR>1 {printf "%s\t%.1f%%\t%s\n", $11, $4, $2}'

# === Stretch Goals ===
echo -e "\n=== Additional Information ==="

# OS Version
echo "OS Version:"
cat /etc/os-release | grep "PRETTY_NAME" | cut -d'"' -f2

# System Uptime
echo -e "\nUptime:"
uptime | awk '{print $3,$4}'

# Load Average
echo -e "\nLoad Average (1min, 5min, 15min):"
uptime | awk -F'load average:' '{print $2}'

# Logged in Users
echo -e "\nCurrently Logged In Users:"
who | wc -l

# Recent Failed Login Attempts
echo -e "\nRecent Failed Login Attempts:"
grep "Failed password" /var/log/auth.log 2>/dev/null | tail -n 5 || echo "No recent failed attempts found"
