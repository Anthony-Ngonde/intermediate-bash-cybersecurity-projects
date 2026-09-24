#!/usr/bin/bash

vulnerability_file=vulnerability_file.txt
current_date=$(date +"%Y-%m-%d")
assessment_report=assessment_report.txt


echo "=============================================="
echo "Linux Vulnerability Assessment & Risk Reporter"
echo "=============================================="


operating_system() {

echo "================="
echo "Operating System"
echo "================"

cat /etc/os-release |
grep "PRETTY_NAME"


echo "$current_date | Operating System Check | LOW | OPEN" >> "$vulnerability_file"


}


kernel_version() {

echo "=============="
echo "Kernel Version"
echo "=============="

uname -r

echo "$current_date | Kernel Version Check | LOW | OPEN" >> "$vulnerability_file"

}


installed_packages_versions() {

echo "==============================="
echo "Installed Packages and Versions"
echo "==============================="

dpkg-query -W -f='${Package} ${Version}\n'

echo "$current_date | Installed Packages Versions | LOW | OPEN" >> "$vulnerability_file"


}


available_security_updates() {

echo "=========================="
echo "Available Security Updates"
echo "=========================="

sudo apt full-upgrade --simulate

echo "$current_date | Available Security Updates | HIGH | OPEN" >> "$vulnerability_file"


}


outdated_packages() {

echo "================"
echo "Outdated Packages"
echo "================="

apt list --upgradable

echo "$current_date | Outdated Packages Check | MEDIUM | OPEN" >> "$vulnerability_file"

}



risky_running_services() {

echo "========================"
echo "Display Running Services"
echo "========================"

ps aux

echo "$current_date | Risky Running Services | CRITICAL | OPEN" >> "$vulnerability_file"


}


check_listening_ports() {

echo "====================="
echo "Check Listening Ports"
echo "====================="

ss -tuln

echo "$current_date | Check Listening Ports | LOW | OPEN" >> "$vulnerability_file"


}


check_firewall_status() {

echo "====================="
echo "Check Firewall Status"
echo "====================="

sudo ufw status

echo "$current_date | Check Firewall Status | HIGH | OPEN" >> "$vulnerability_file"


}


important_file_permissions() {

echo "=========================="
echo "Important File Permissions"
echo "=========================="

echo
echo "Note: Enter /etc/passwd, /etc/shadow, /etc/group, /etc/sudoers"

echo
read -p "Enter file name: " file

permissions=$(ls -l "$file")

echo "Permissions: $permissions"


echo "$current_date | Check File Permissions | MEDIUM | OPEN" >> "$vulnerability_file"


}


view_vulnerability_file() {

echo "=================="
echo "VULNERABILITY FILE"
echo "=================="

if [ -s "$vulnerability_file"  ]
   then
     cat "$vulnerability_file"
   else
     echo "File not found"

fi


}


delete_vulnerability_entry() {

echo "=========================="
echo "Delete Vulnerability Entry"
echo "=========================="

echo
cat "$vulnerability_file"

echo
read -p "Enter entry to delete: " entry

sed -i "/$entry/d" "$vulnerability_file"

echo
echo "Entry Deleted Successfully"


}


count_severity_alerts() {

echo "====================="
echo "Count Severity Alerts"
echo "====================="

while IFS='|' read -r date security severity findings
do

severity=$(echo "$severity" | xargs)


if [ "$severity" = "LOW"  ]; then
    ((low++))

elif [ "$severity" = "MEDIUM"  ]; then
     ((medium++))

elif [ "$severity" = "HIGH"  ]; then
     ((high++))

elif [ "$severity" = "CRITICAL"  ]; then
     ((critical++))

fi


done < "$vulnerability_file"

echo
echo "LOW: $low"
echo "MEDIUM: $medium"
echo "HIGH: $high"
echo "CRITICAL : $critical"


}


generate_assessment_report() {

{


echo "====================================="
echo "LINUX VULNERABILITY ASSESSMENT REPORT"
echo "====================================="
echo
echo "Generated: $current_date"


echo
echo "================="
echo "Operating System"
echo "================="

cat /etc/os-release |
grep "PRETTY_NAME"


echo
echo "==============="
echo "Kernel Version"
echo "=============="

uname -r


echo
echo "==============================="
echo "Installed Packages and Versions"
echo "==============================="

dpkg-query -W -f='${Package} ${Version}\n'

echo
echo "==========================="
echo "Available Security Updates"
echo "==========================="

sudo apt full-upgrade --simulate


echo
echo "=================="
echo "Outdated Packages"
echo "================="

apt list --upgradable


echo
echo "======================"
echo "Risky Running Services"
echo "======================"

ps aux


echo
echo "====================="
echo "Check Listening Ports"
echo "====================="

ss -tuln

echo
echo "====================="
echo "Check Firewall Status"
echo "====================="

sudo ufw status


} > "$assessment_report"

echo
echo "Report Generated Successfully in $assessment_report"


}




while true
do


echo
echo "1.Operating System"
echo "2.Kernel Version"
echo "3.Installed Packages and Version"
echo "4.Available Security Updates"
echo "5.Identify Outdated Packages"
echo "6.Display Running Services"
echo "7.Check Listening Ports"
echo "8.Check Firewall Status"
echo "9.Check Important File Permissions"
echo "10.View Vulnerability File"
echo "11.Delete Vulnerability Entry"
echo "12.Count Severity Alerts"
echo "13.Generate Assessment Report"
echo "14.Exit"

echo
read -p "Enter your choice: " choice


case $choice in

1)
 operating_system
 ;;

2)
 kernel_version
 ;;

3)
 installed_packages_versions
 ;;

4)
 available_security_updates
 ;;

5)
 outdated_packages
 ;;

6)
 risky_running_services
 ;;

7)
 check_listening_ports
 ;;

8)
 check_firewall_status
 ;;

9)
 important_file_permissions
 ;;

10)
 view_vulnerability_file
 ;;

11)
 delete_vulnerability_entry
 ;;

12)
 count_severity_alerts
 ;;

13)
 generate_assessment_report
 ;;

14)
 echo "Goodbye!"
 exit

esac


echo
read -p "Press Enter to Continue..."



done
