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
lastreboot=$(who -b | awk '{print $3 " " $4}')
lvmactive=$(if [ $lvm -eq 0 ]; then echo "${RED}Not present$NC"; else echo "${GREEN}Present$NC"; fi)

#SCRIPT
echo -e	"${YELLOW}monitoring.sh$NC
$GRAY#Arc$NC		: $arc
$GRAY#pCPU$NC		: $pcpu
$GRAY#vCPU$NC		: $vcpu
$GRAY#RAM$NC		: $ram
$GRAY#Disk$NC		: $disk
$GRAY#Last boot$NC	: $lastreboot
$GRAY#LVM$NC		: $lvmactive
"
