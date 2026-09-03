#!/usr/bin/bash

echo "============================="
echo "Automated Security Audit Tool"
echo "============================="


user_root_status() {

echo "========================"
echo "Current/Root User Status"
echo "========================"

user=$(whoami)

echo "Current User: $user"

if [ "$EUID" -eq 0  ]
  then
    echo "Privilege Level: ROOT USER"
  else
    echo "Privilege Level: STANDARD USER"

fi

}

operating_system_info() {

echo "============================"
echo "Operating System Information"
echo "============================"

cat /etc/os-release

}


disk_usage_checker() {

echo "=========="
echo "Disk Usage"
echo "=========="

df -h / |
awk 'NR==2 {print $5}'


}


failed_running_services() {

echo "========================"
echo "Display Failed Running Services"
echo "========================"

systemctl --failed --no-legend

}


listening_ports_checker() {

echo "======================="
echo "Display Listening Ports"
echo "======================="

ss -tuln

}

active_connections_checker() {

echo "=========================="
echo "Display Active Connections"
echo "=========================="

ss -tun

}


firewall_status_checker() {

echo "======================="
echo "Display Firewall Status"
echo "======================="

sudo ufw status

}


failed_ssh_attempts() {

echo "==================="
echo "Failed SSH Attempts"
echo "==================="

sudo journalctl -u ssh

}


users_with_login_shells() {

echo "======================="
echo "Users with Login Shells"
echo "======================="

grep -E '/bin/(bash|zh|ssh)$' /etc/passwd |
cut -d ':' -f1

}


sensitive_files_permissions() {

echo "============================================"
echo "File Permissions on Selected Sensitive Files"
echo "============================================"

echo
echo "Note: Enter: /etc/shadow or /etc/passwd"

read -p "Enter filename: " file

stat -c "%A" "$file"


}


display_suspicious_processes() {

echo "============================"
echo "Display Suspicious Processes"
echo "============================"

read -p "Enter Process Name: " process

ps aux | grep "$process"


}


while true
do


echo
echo "1.Current/Root User Status"
echo "2.Operating System Information"
echo "3.Disk Usage"
echo "4.Display Running Services"
echo "5.Display Listening Ports"
echo "6.Display Active Connections"
echo "7.Display Firewall Status"
echo "8.Failed SSH Attempts"
echo "9.Users with Login Shells"
echo "10.File Permissions on Selected Sensitive Files"
echo "11.Display Suspicious Processes"
echo "12.Exit"


read -p "Enter your choice: " choice


case $choice in


1)
 user_root_status
 ;;

2)
 operating_system_info
 ;;

3)
 disk_usage_checker
 ;;

4)
 failed_running_services
 ;;

5)
 listening_ports_checker
 ;;

6)
 active_connections_checker
 ;;

7)
 firewall_status_checker
 ;;

8)
 failed_ssh_attempts
 ;;

9)
 users_with_login_shells
 ;;

10)
 sensitive_files_permissions
 ;;

11)
 display_suspicious_processes
 ;;

12)
 echo "Goodbye!"
 exit

esac


read -p "Press Enter to Continue..."


done
