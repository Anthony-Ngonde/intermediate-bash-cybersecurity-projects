#!/usr/bin/bash

echo "==============================="
echo "SOC Monitoring and Alert System"
echo "==============================="

current_date=$(date)
base_hash=base_hash.txt
current_hash=current_hash.txt
base_scan=base_scan.txt
current_scan=current_scan.txt
new_port=new_port.txt
closed_port=closed_port.txt
security_log=security_log.txt
disk_usage=disk_usage.txt



failed_ssh_logins() {

echo "================="
echo "Failed SSH Logins"
echo "================="

sudo journalctl -u ssh |
grep "Failed password"

echo "$current_date | Failed Login Attempts | HIGH" >> "$security_log"

}


failed_ssh_logins_ip() {

echo "================================="
echo "Failed Login Attempt from same IP"
echo "================================="

sudo journalctl -u ssh |
grep "Failed password" |
awk '{print $11}'

echo "$current_date | Failed Login IP Attempts | HIGH" >> "$security_log"

}


new_listening_ports() {

echo "==================="
echo "New Listening Ports"
echo "==================="


if [ ! -f "$base_scan"  ]
  then
   nmap -p- localhost |
   grep "/tcp" |
   awk '{print $1}' |
   tr -d '/tcp' > "$base_scan"

   cat "$base_scan"

   return

fi


nmap -p- localhost |
grep "/tcp" |
awk '{print $1}' |
tr -d '/tcp' > "$current_scan"


if cmp -s "$base_scan" "$current_scan"
  then
    echo
    echo "No Port Changes Detected"
  else
    echo
    echo "Port Changes Detected"
    cat "$current_scan"
    comm -13 "$base_scan" "$current_scan" > "$new_port"
    echo
    echo "Newly Opened Ports: "
    cat "$new_port"

    comm -23 "$base_scan" "$current_scan" > "$closed_port"
    echo
    echo "Closed Ports: "
    cat "$closed_port"

#    cp "$current_scan" "$base_scan"

fi

}


file_integrity_checker() {

echo "======================"
echo "File Integrity Changes"
echo "======================"


if [ ! -f "$base_hash"  ]
  then
   read -p "Enter filename: " file

   sha256sum "$file" > "$base_hash"
   return

fi


read -p "Enter filename: " file

sha256sum "$file" > "$current_hash"

if cmp -s "$base_hash" "$current_hash"
   then
    echo "The file is Unchanged"
   else
    echo "The file is Modified"
    echo "$current_date | File Change Detected | LOW" >> "$security_log"

fi


}


disk_usage_checker() {

echo "=================="
echo "Disk Usage Checker"
echo "=================="

df -h / |
awk 'NR==2 {print $5}' |
tr -d '%' > "$disk_usage"

cat "$disk_usage"


if [ "$disk_usage" -ge 90  ]
  then
    echo "$current_date | Disk Usage | CRITICAL" >> "$security_log"

elif [ "$disk_usage" -ge 70  ]
   then
    echo "$current_date | Disk Usage | HIGH" >> "$security_log"

elif [ "$disk_usage" -ge 40  ]
   then
    echo "$current_date | Disk Usage | MEDIUM" >> "$security_log"

   else
   echo "$current_date | Disk Usage | LOW" >> "$security_log"


fi

}


display_sus_processes() {

echo "============================"
echo "Display Suspicious Processes"
echo "============================"

read -p "Enter Process Name: " process

ps aux | grep "$process"


}


display_network_connections() {

echo "==========================="
echo "Display Network Connections"
echo "==========================="

ss -tunap

}


view_log_file() {

echo "======================"
echo "View Security Log File"
echo "======================"

if [ -s "$security_log"  ]
  then
   cat "$security_log"
  else
   echo "Security Log file not found"

fi


}


delete_log_input() {

echo "=============================="
echo "Delete Security Log File Input"
echo "=============================="

cat "$security_log"

read -p "Enter process: " process


if grep -iq "$process" "$security_log"
  then
   sed -i "/$process/Id" "$security_log"
   echo "Security Log Input deleted successfully"

   else
   echo "Security Log Input not found"

fi


}



while true
do


echo
echo "1.Failed SSH Logins"
echo "2.Failed Login Attempts from same IP"
echo "3.New Listening Ports"
echo "4.File Integrity Changes"
echo "5.Disk Usage"
echo "6.Display Suspicious Processes"
echo "7.Display Network Connections"
echo "8.View Security Log File"
echo "9.Delete Security Log File Input"
echo "10.Exit"


read -p "Enter your choice: " choice


case $choice in

1)
 failed_ssh_logins
 ;;

2)
 failed_ssh_logins_ip
 ;;

3)
 new_listening_ports
 ;;

4)
 file_integrity_checker
 ;;

5)
 disk_usage_checker
 ;;

6)
 display_sus_processes
 ;;

7)
 display_network_connections
 ;;

8)
 view_log_file
 ;;

9)
 delete_log_input
 ;;

10)
 echo "Goodbye!"
 exit

esac


read -p "Press Enter to Continue..."


done



