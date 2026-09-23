#!/usr/bin/bash


echo "=============================================="
echo "Linux Vulnerability Assessment & Risk Reporter"
echo "=============================================="


operating_system() {

echo "================="
echo "Operating System"
echo "================"

cat /etc/os-release |
grep "PRETTY_NAME"


}

kernel_version() {

echo "=============="
echo "Kernel Version"
echo "=============="

uname -r

}


while true
do


echo
echo "1.Operating System"
echo "2.Kernel Version"
echo "3.Exit"

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
 echo "Goodbye!"
 exit

esac


echo
read -p "Press Enter to Continue..."



done
