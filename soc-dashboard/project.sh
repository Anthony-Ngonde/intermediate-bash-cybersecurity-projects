#!/usr/bin/bash

echo "==============================="
echo "SOC Monitoring and Alert System"
echo "==============================="


failed_ssh_logins() {

echo "================="
echo "Failed SSH Logins"
echo "================="

sudo journalctl -u ssh |
grep "Failed password" 



}


new_listening_ports() {

echo "==================="
echo "New Listening Ports"
echo "==================="

nmap -p- localhost |
grep "/tcp" |
awk '{print $1}' |
tr -d '/tcp'


}

#failed_ssh_logins
new_listening_ports

