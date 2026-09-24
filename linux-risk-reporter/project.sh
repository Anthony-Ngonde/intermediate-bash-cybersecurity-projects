#!/usr/bin/bash

vulnerability_file=vulnerability_file.txt
current_date=$(date +"%Y-%m-%d")


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



display_running_services() {

echo "========================"
echo "Display Running Services"
echo "========================"

ps aux

echo "$current_date | Display Running Services | LOW | OPEN" >> "$vulnerability_file"


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
echo "10.Exit"

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
 display_running_services
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
 echo "Goodbye!"
 exit

esac


echo
read -p "Press Enter to Continue..."



done
