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
disk_usage=$(cat disk_usage.txt)
security_report=security_report.txt



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
awk '{print $11}' |
sort |
uniq -c |
sort -nr


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

file="$1"

echo "======================"
echo "File Integrity Changes"
echo "======================"

if [ -z "$file"  ]
  then
   read -p "Enter filename: " file

fi


if [ ! -f "$base_hash"  ]
  then
   read -p "Enter filename: " file

   sha256sum "$file" > "$base_hash"
   return

fi


#read -p "Enter filename: " file

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

process="$1"

echo "============================"
echo "Display Suspicious Processes"
echo "============================"

if [ -z "$process"  ]
  then
   read -p "Enter Process Name: " process

fi

#read -p "Enter Process Name: " process

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



count_security_alerts() {

echo "====================="
echo "Count Security Alerts"
echo "====================="

total=0
low=0
medium=0
high=0
critical=0

while IFS='|' read -r date process severity
do

severity=$(echo "$severity" | xargs)

total=$((total + 1))

case $severity in

LOW)
  low=$((low + 1))
  ;;

MEDIUM)
  medium=$((medium + 1))
  ;;

HIGH)
  high=$((high + 1))
  ;;

CRITICAL)
  critical=$((critical + 1))
  ;;

esac

done < "$security_log"

echo
echo "Total Severity Alerts: $total"
echo "Low Alerts: $low"
echo "Medium Alerts: $medium"
echo "High Alerts: $high"
echo "Critical Alerts: $critical"

}



run_security_checks() {

echo "======================="
echo "Run All Security Checks"
echo "======================="

echo
failed_ssh_logins
echo

echo
failed_ssh_logins_ip
echo

echo
new_listening_ports
echo

echo
file_integrity_checker "dummy.txt"
echo

echo
disk_usage_checker
echo

echo
display_sus_processes "sleep"
echo

echo
display_network_connections
echo

}


continuous_security_checks() {

echo "====================================="
echo "Continuous Monitoring Security Checks"
echo "====================================="


read -p "Enter Intervals in seconds: " interval

while true
do

run_security_checks

echo
echo "Next security check in $interval seconds"
echo "Press Ctrl + C to exit"

sleep "$interval"

done

}


generate_security_report() {

{

echo "============================="
echo "SOC DASHBOARD SECURITY REPORT"
echo "============================="
echo "Generated: $current_date"
echo

echo "==============="
echo "SECURITY ALERTS"
echo "==============="

if [ -s "$security_log"  ]
   then
    cat "$security_log"
   else
    echo "Security log file not found"

fi


echo
echo "============"
echo "ALERT COUNTS"
echo "============"

echo "LOW: $(grep -c '| LOW' "$security_log")"
echo "MEDIUM: $(grep -c '| MEDIUM' "$security_log")"
echo "HIGH: $(grep -c '| HIGH' "$security_log")"
echo "CRITICAL: $(grep -c '| CRITICAL' "$security_log")"


echo
echo "======================="
echo "CURRENT LISTENING PORTS"
echo "======================="

nmap -p- localhost


echo
echo "=================="
echo "CURRENT DISK USAGE"
echo "=================="

df -h / |
awk 'NR==2 {print $5}'


echo
echo "==========================="
echo "DISPLAY NETWORK CONNECTIONS"
echo "==========================="

ss -tunap


} > "$security_report"

echo
echo "Report Generated successfully in $security_report"

}


view_security_report() {

if [ -s "$security_report"  ]
  then
    cat "$security_report"
  else
    echo "Security report not found"

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
echo "10.Count Security Alerts"
echo "11.Run All Security Checks"
echo "12.Continuous Security Monitoring Checks"
echo "13.Generate Security Report"
echo "14.View Security Report"
echo "15.Exit"


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
 file_integrity_checker "dummy.txt"
 ;;

5)
 disk_usage_checker
 ;;

6)
 display_sus_processes "sleep"
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
 count_security_alerts
 ;;

11)
 run_security_checks
 ;;

12)
 continuous_security_checks
 ;;

13)
 generate_security_report
 ;;

14)
 view_security_report
 ;;

15)
 echo "Goodbye!"
 exit


esac



read -p "Press Enter to Continue..."



done



