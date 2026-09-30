#!/usr/bin/bash

echo "============================================="
echo "Linux Incident Response Investigation Console"
echo "============================================="


system_information() {

echo "=================="
echo "System Information"
echo "=================="

uname -a


}


loggedin_users() {

echo "================"
echo "Logged-in Users"
echo "================"

w

}


failed_ssh_logins() {

echo "================="
echo "Failed SSH Logins"
echo "================="

sudo journalctl -u ssh |
grep "Failed"


}



running_processes() {

echo "================="
echo "Running Processes"
echo "================="

ps aux

}


listening_ports() {

echo "==============="
echo "Listening Ports"
echo "==============="

ss -tuln

}


active_connections() {

echo "==================="
echo "Active Cocnnections"
echo "==================="

ss -tun


}

recently_modified_files() {

echo "======================="
echo "Recently Modified Files"
echo "======================="

find /home/anthony -type f -mmin -60 2>/dev/null

}



search_ioc() {

echo "============="
echo "Search IOC"
echo "============"

read -p "Enter IOC: " ioc

sudo journalctl -u ssh |
grep -i "$ioc"

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
echo "9.Exit"

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
 echo "Goodbye!"
 exit


esac

echo
read -p "Press Enter to Continue..."


done
