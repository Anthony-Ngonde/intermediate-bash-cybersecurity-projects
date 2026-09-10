#!/usr/bin/bash

echo "======================="
echo "Network Packet Analyzer"
echo "======================="

captured_packets=captured_packets.pcap
packets_summary=packets_summary.txt
current_date=$(date)


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

sudo tcpdump -i "$interface" -c 10 >> "$captured_packets"

}


capture_tcp_packets() {

echo "==================="
echo "Capture TCP Packets"
echo "==================="

echo "Note: Enter lo/eth0"

read -p "Enter Interface Name: " interface

sudo tcpdump -i "$interface" tcp -c 10 |
sed 's/^/[TCP] /' >> "$captured_packets"


}


capture_udp_packets() {

echo "==================="
echo "Capture UDP Packets"
echo "==================="

echo "Note: Enter lo/eth0"

read -p "Enter Interface Name: " interface

sudo tcpdump -i "$interface" udp -c 10 |
sed 's/^/[UDP] /' >> "$captured_packets"


}


capture_icmp_packets() {

echo "===================="
echo "Capture ICMP Packets"
echo "===================="

echo "Note: Enter lo/eth0"

read -p "Enter Interface Name: " interface

sudo tcpdump -i "$interface" udp -c 10 |
sed 's/^/[ICMP] /' >> "$captured_packets"


}


filter_by_ip() {

echo "===================="
echo "Filter by IP Address"
echo "===================="

echo "Note: Enter lo/eth0"

read -p "Enter Interface name: " interface

read -p "Enter IP Address: " ip

sudo tcpdump -i "$interface" host "$ip" -c 10 >> "$captured_packets" 


}


filter_by_port() {

echo "=============="
echo "Filter by Port"
echo "=============="

echo "Note: Enter lo/eth0"

read -p "Enter Interface name: " interface

read -p "Enter Port Number: " number

sudo tcpdump -i "$interface" port "$number" -c 10 >> "$captured_packets"


}


view_saved_captures() {

echo "==================="
echo "View Saved Captures"
echo "==================="

if [ -s "$captured_packets"  ]
   then
     cat "$captured_packets"
   else
     echo "No file found."

fi


}


packets_traffic_summary() {

{


if [ ! -f "$captured_packets"  ]
   then
     echo "No captured packets found"
     return

fi


total_packets=$(grep -c "^" "$captured_packets")

tcp_packets=$(grep -c "TCP" "$captured_packets")

udp_packets=$(grep -c "UDP" "$captured_packets")

icmp_packets=$(grep -c "ICMP" "$captured_packets")


echo
echo "=================="
echo "Traffic Statistics"
echo "=================="
echo
echo "Generated: $current_date"
echo
echo "Total Packets: $total_packets"
echo "TCP Packets: $tcp_packets"
echo "UDP Packets: $udp_packets"
echo "ICMP Packets: $icmp_packets"


} >> "$packets_summary"

echo
echo "Packets Traffic Summary saved to $packets_summary"

}


view_packets_traffic() {

if [ -f "$packets_summary"  ]
  then
    cat "$packets_summary"
   else
    echo "No file found"

fi

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
echo "7.Filter by Port"
echo "8.View Saved Captured Packets"
echo "9.Generate Packets Traffic Summary"
echo "10.View Packets Traffic Summary"
echo "11.Exit"


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
 filter_by_port
 ;;

8)
 view_saved_captures
 ;;

9)
 packets_traffic_summary
 ;;

10)
 view_packets_traffic
 ;; 

11)
 echo "Goodbye!"
 exit


esac


read -p "Press Enter to Continue..."



done
