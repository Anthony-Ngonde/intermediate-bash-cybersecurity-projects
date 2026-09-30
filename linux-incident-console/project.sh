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



system_information

loggedin_users
