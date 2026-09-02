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

user_root_status

operating_system_info

