#!/usr/bin/bash

echo "=============================================="
echo "Linux User, Group & Privilege Security Auditor"
echo "=============================================="



list_all_users() {

echo "=============="
echo "List All Users"
echo "=============="

cat /etc/passwd


}


users_with_login_shells() {

echo "======================="
echo "Users with Login Shells"
echo "======================="

awk -F: '$7 !~ /(nologin|false)$/ {print $1}' /etc/passwd

}


while true
do


echo
echo "1.List All Users"
echo "2.Identify Users with Login Shells"
echo "3.Exit"


echo
read -p "Enter your choice: " choice


case $choice in

1)
 list_all_users
 ;;

2)
 users_with_login_shells
 ;;

3)
 echo "Goodbye!"
 exit

esac


echo
read -p "Press Enter to Continue..."


done
