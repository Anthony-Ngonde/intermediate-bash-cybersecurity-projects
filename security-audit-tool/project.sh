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


while true
do


echo
echo "1.Current/Root User Status"
echo "2.Operating System Information"
echo "3.Disk Usage"
echo "4.Display Running Services"
echo "5.Display Listening Ports"
echo "6.Exit"


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
 echo "Goodbye!"
 exit

esac


read -p "Press Enter to Continue..."


done
