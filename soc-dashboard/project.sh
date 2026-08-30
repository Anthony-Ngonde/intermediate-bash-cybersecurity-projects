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

failed_count=$(sudo journalctl -u ssh | grep -c "Failed password")

if [ "$failed_count" -gt 0  ]
  then
    echo "Failed SSH logins: $failed_count"
    echo "$current_date | Failed Login Attempts: $failed_count | HIGH" >> "$security_log"

  else
    echo "No failed SSH logins detected"

fi

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

new_port=$(comm -13 "$base_scan" "$current_scan")

if [ -n "$new_port"  ]
  then
   echo "$current_date | Newly Opened ports: $new_port | HIGH" >> "$security_log"

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

ram_usage_checker() {

echo "================="
echo "RAM Usage Checker"
echo "================="

free -h |
awk 'NR==2 {print $3}'


}


cpu_usage_checker() {

echo "================="
echo "CPU Usage Checker"
echo "================="

top -bn1 |
awk '/Cpu/ {print 100-$8}'

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
ram_usage_checker
echo

echo
cpu_usage_checker
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

if ! [[ "$interval" =~ ^[0-9]+$ ]] || [ "$interval" -le 0  ]
   then
     echo "Invalid monitoring interval"
   return

fi


while true
do

echo
echo "Security scan started: $current_date"


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

ss -tuln


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
echo "6.RAM Usage"
echo "7.CPU Usage"
echo "8.Display Suspicious Processes"
echo "9.Display Network Connections"
echo "10.View Security Log File"
echo "11.Delete Security Log File Input"
echo "12.Count Security Alerts"
echo "13.Run All Security Checks"
echo "14.Continuous Security Monitoring Checks"
echo "15.Generate Security Report"
echo "16.View Security Report"
echo "17.Exit"


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
 ram_usage_checker
 ;;

7)
 cpu_usage_checker
 ;;

8)
 display_sus_processes "sleep"
 ;;

9)
 display_network_connections
 ;;

10)
 view_log_file
 ;;

11)
 delete_log_input
 ;;

12)
 count_security_alerts
 ;;

13)
 run_security_checks
 ;;

14)
 continuous_security_checks
 ;;

15)
 generate_security_report
 ;;

16)
 view_security_report
 ;;

17)
 echo "Goodbye!"
 exit


esac



read -p "Press Enter to Continue..."



done



