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


file_integrity_checker() {

echo "======================"
echo "File Integrity Changes"
echo "======================"



}


while true
do


echo
echo "1.Failed SSH Logins"
echo "2.New Listening Ports"
echo "3.Exit"


read -p "Enter your choice: " choice


case $choice in

1)
 failed_ssh_logins
 ;;

2)
 new_listening_ports
 ;;

3)
 echo "Goodbye!"
 exit

esac


read -p "Press Enter to Continue..."


done



