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


installed_packages_versions() {

echo "==============================="
echo "Installed Packages and Versions"
echo "==============================="

dpkg-query -W -f='${Package} ${Version}\n'


}


available_security_updates() {

echo "=========================="
echo "Available Security Updates"
echo "=========================="

sudo apt full-upgrade --simulate


}


outdated_packages() {

echo "================"
echo "Outdated Packages"
echo "================="

apt list --upgradable


}

display_running_services() {

echo "========================"
echo "Display Running Services"
echo "========================"

ps aux

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
echo "7.Exit"

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
 echo "Goodbye!"
 exit

esac


echo
read -p "Press Enter to Continue..."



done
