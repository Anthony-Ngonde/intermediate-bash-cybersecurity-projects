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


capture_tcp_packets() {

echo "==================="
echo "Capture TCP Packets"
echo "==================="

echo "Note: Enter lo/eth0"

read -p "Enter Interface Name: " interface

sudo tcpdump -i "$interface" tcp -c 10


}


capture_udp_packets() {

echo "==================="
echo "Capture UDP Packets"
echo "==================="

echo "Note: Enter lo/eth0"

read -p "Enter Interface Name: " interface

sudo tcpdump -i "$interface" udp -c 10


}


capture_icmp_packets() {

echo "===================="
echo "Capture ICMP Packets"
echo "===================="

echo "Note: Enter lo/eth0"

read -p "Enter Interface Name: " interface

sudo tcpdump -i "$interface" udp -c 10

}


filter_by_ip() {

echo "===================="
echo "Filter by IP Address"
echo "===================="

echo "Note: Enter lo/eth0"

read -p "Enter Interface name: " interface

read -p "Enter IP Address: " ip

sudo tcpdump -i "$interface" host "$ip" -c 10 


}




while true
do


echo
echo "1.List Network Interfaces"
echo "2.Capture Packets"
echo "3.Capture TCP Packets"
echo "4.Capture UDP Packets"
echo "5.Capture ICMP Packets"
echo "6.Filter by IP Address"
echo "7.Exit"


read -p "Enter your choice: " choice


case $choice in

1)
 list_network_interfaces
 ;;

2)
 capture_packets_function
 ;;

3)
 capture_tcp_packets
 ;;

4)
 capture_udp_packets
 ;;

5)
 capture_icmp_packets
 ;;

6)
 filter_by_ip
 ;;

7)
 echo "Goodbye!"
 exit


esac


read -p "Press Enter to Continue..."



done
