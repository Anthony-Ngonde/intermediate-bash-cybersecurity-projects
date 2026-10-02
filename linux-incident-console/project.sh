#!/usr/bin/bash

echo "============================================="
echo "Linux Incident Response Investigation Console"
echo "============================================="

current_date=$(date +%H:%M)
incident_timeline=incident_timeline.txt
investigation_notes=investigation_notes.txt
security_report=security_report.txt


system_information() {

echo "=================="
echo "System Information"
echo "=================="

uname -a

echo "$current_date | SYSTEM | System infomation" >> "$incident_timeline"

}


loggedin_users() {

echo "================"
echo "Logged-in Users"
echo "================"

w

echo "$current_date | AUTH | Logged-in Users" >> "$incident_timeline"

}


failed_ssh_logins() {

echo "================="
echo "Failed SSH Logins"
echo "================="

sudo journalctl -u ssh |
grep "Failed"

echo "$current_date | AUTH | Failed SSH Logins" >> "$incident_timeline"


}



running_processes() {

echo "================="
echo "Running Processes"
echo "================="

ps aux

echo "$current_date | PROCESS | Running Processes" >> "$incident_timeline"

}



listening_ports() {

echo "==============="
echo "Listening Ports"
echo "==============="

ss -tuln

echo "$current_date | NETWORK | Listening Ports" >> "$incident_timeline"

}


active_connections() {

echo "==================="
echo "Active Cocnnections"
echo "==================="

ss -tun

echo "$current_date | NETWORK | Active Connections" >> "$incident_timeline"

}


recently_modified_files() {

echo "======================="
echo "Recently Modified Files"
echo "======================="

find /home/anthony -type f -mmin -60 2>/dev/null

echo "$current_date | FILE | Recently Modified Files" >> "$incident_timeline"

}



search_ioc() {

echo "============="
echo "Search IOC"
echo "============"

read -p "Enter IOC: " ioc

sudo journalctl -u ssh |
grep -i "$ioc"

}


investigation_note() {

read -p "Enter investigation note: " note

echo "$current_date | $note" >> "$investigation_notes"

echo "Investigation note recorded"


}


view_incident_report() {

if [ -s "$incident_timeline"  ]
   then
     cat "$incident_timeline"
   else
     echo "File not found"

fi


}


view_investigation_note() {

if [ -s "$investigation_notes"  ]
   then
     cat "$investigation_notes"
   else
     echo "No file found"

fi

}


generate_incident_report() {


{


echo "========================="
echo "SECURITY INCIDENT REPORT"
echo "========================"
echo
echo "Generated: $(date)"

echo
echo "=================="
echo "System Information"
echo "=================="

uname -a


echo
echo "================="
echo "Logged-In Users"
echo "================="

w



echo
echo "================="
echo "Failed SSH Logins"
echo "================="

sudo journalctl -u ssh |
grep "Failed password"


echo
echo "================="
echo "Running Processes"
echo "================="


ps aux




echo
echo "================"
echo "Listening Ports"
echo "================"

ss -tuln



echo
echo "=================="
echo "Active Connections"
echo "=================="

ss -tun



echo
echo "======================="
echo "Recently Modified Files"
echo "======================="

find /home/anthony -type f -mmin -60 2>/dev/null



if [ -s "$incident_timeline" ]
  then
    echo
    echo
    cat "$incident_timeline"
  else
    echo
    echo
    echo "File not found"

fi




} > "$security_report"

echo
echo "Report generated successfully in $security_report"


}




while true
do


echo
echo "1.System Information"
echo "2.Logged-in Users"
echo "3.Failed SSH Logins"
echo "4.Running Processes"
echo "5.Listening Ports"
echo "6.Active COnnections"
echo "7.Recently Modified Files"
echo "8.Search IOC"
echo "9.Record Investigation Note"
echo "10.View Incident Timeline"
echo "11.View Investigation Notes"
echo "12.Generate Incident Report"
echo "13.Exit"

echo
read -p "Enter your choice: " choice


case $choice in

1)
 system_information
 ;;

2)
 loggedin_users
 ;;

3)
 failed_ssh_logins
 ;;

4)
 running_processes
 ;;

5)
 listening_ports
 ;;

6)
 active_connections
 ;;

7)
 recently_modified_files
 ;;

8)
 search_ioc
 ;;

9)
 investigation_note
 ;;

10)
 view_incident_report
 ;;

11)
 view_investigation_note
 ;;

12)
 generate_incident_report
 ;;

13)
 echo "Goodbye!"
 exit


esac

echo
read -p "Press Enter to Continue..."


done
