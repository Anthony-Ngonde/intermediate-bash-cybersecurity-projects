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


while true
do


echo
echo "1.System Information"
echo "2.Logged-in Users"
echo "3.Exit"

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
 echo "Goodbye!"
 exit


esac

echo
read -p "Press Enter to Continue..."


done
