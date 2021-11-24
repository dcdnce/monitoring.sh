#!/bin/bash
#COLORS
NC='\033[0m'
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
GRAY='\033[1;30m'
BLUE='\033[0;34m'

totalram=$(free -m | grep "Mem:" | awk '{print $2}')
usedram=$(free -m | grep "Mem:" | awk '{print $3}')
totaldisk=$(df -Bm | grep '^/dev/' | grep -v '/boot'| awk '{td += $2} END {print td}')
useddisk=$(df -Bm | grep '^/dev/' | grep -v '/boot'| awk '{ud += $3} END {print ud}')
lvm=$(lsblk | grep "lvm" | wc -l)

arc=$(uname -m | tr -d '\n' && echo -n " with $(uname -s) " && uname -v)
pcpu=$(lscpu | grep "CPU(s)" | awk 'NR==1{print $NF}')
vcpu=$(grep "processor" /proc/cpuinfo | wc -l)
ram=$(echo "total ${totalram}M used $((usedram*100/totalram))%")
disk=$(echo "total ${totaldisk}M used $((useddisk*100/totaldisk))%")
cpu=$(top -bn1 | grep '^%Cpu' | cut -c 9- | xargs | awk '{printf("%.1f%%"), $1 + $3}')
lastreboot=$(who -b | awk '{print $3 " " $4}')
lvmactive=$(if [ $lvm -eq 0 ]; then echo "${RED}Not present$NC"; else echo "${GREEN}Present$NC"; fi)
tcp=$(netstat -s | grep 'active connection openings' | awk '{print $1 " " $2 " " $3}')
users=$(echo -n "$(users | wc -w) " && echo -n  "connected")
ip=$(hostname -I)
mac=$(ip link show | grep "link/ether" | awk '{print $2}')
cmd=$(journalctl _COMM=sudo | grep COMMAND | wc -l)

#SCRIPT
wall "$(echo -e "${YELLOW}monitoring.sh$NC")
$(echo -e "$GRAY#Arc$NC		: $arc")
$(echo -e "$GRAY#pCPU$NC		: $pcpu")
$(echo -e "$GRAY#vCPU$NC		: $vcpu")
$(echo -e "$GRAY#RAM$NC		: $ram")
$(echo -e "$GRAY#Disk$NC		: $disk")
$(echo -e "$GRAY#Cpu$NC		: $cpu")
$(echo -e "$GRAY#Last boot$NC	: $lastreboot")
$(echo -e "$GRAY#LVM$NC		: $lvmactive")
$(echo -e "$GRAY#TCP$NC		: $tcp")
$(echo -e "$GRAY#Users$NC		: $users")
$(echo -e "$GRAY#IP$NC		: $ip")
$(echo -e "$GRAY#Mac$NC		: $mac")
$(echo -e "$GRAY#Sudo cmds$NC	: $cmd")"
