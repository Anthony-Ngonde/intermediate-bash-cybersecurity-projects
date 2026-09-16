#!/usr/bin/bash

echo "=============================="
echo "Web Server Log Threat Analyzer"
echo "=============================="


log_file=test_access.log


most_active_ips() {

echo "==============="
echo "Most Active IPs"
echo "==============="

awk 'NF > 0 {print $1}' "$log_file" | sort | uniq -c | sort -nr | head -2


}

404_errors() {

echo "============="
echo "404 Errors"
echo "============"

awk '$9 == 404' "$log_file"


}


403_errors() {

echo "============"
echo "403 Errors"
echo "==========="

awk '$9 == 403' "$log_file"


}



while true
do


echo
echo "1.Most Active IPs"
echo "2.404 Errors"
echo "3.403 Erros"
echo "4.Exit"

echo
read -p "Enter your choice: " choice


case $choice in

1)
 most_active_ips
 ;;

2)
 404_errors
 ;;

3)
 403_errors
 ;;

4)
 echo "Goodbye!"
 exit

esac


echo
read -p "Press Enter to Continue..."



done
