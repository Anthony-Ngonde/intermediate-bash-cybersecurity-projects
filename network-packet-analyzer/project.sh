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




#list_network_interfaces
capture_packets_function

