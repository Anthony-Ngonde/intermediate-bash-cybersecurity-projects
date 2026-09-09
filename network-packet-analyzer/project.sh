#!/usr/bin/bash

echo "======================="
echo "Network Packet Analyzer"
echo "======================="


list_network_interfaces() {

echo "======================="
echo "List Network Interfaces"
echo "======================="

ip -br link

}


capture_packets_function() {

echo "==============="
echo "Capture Packets"
echo "==============="

echo "Note: Enter lo/eth0"

read -p "Enter Interface Name: " interface

sudo tcpdump -i "$interface" -c 10 

}


while true
do


echo
echo "1.List Network Interfaces"
echo "2.Capture Packets"
echo "3.Exit"


read -p "Enter your choice: " choice


case $choice in

1)
 list_network_interfaces
 ;;

2)
 capture_packets_function
 ;;

3)
 echo "Goodbye!"
 exit


esac


read -p "Press Enter to Continue..."



done
