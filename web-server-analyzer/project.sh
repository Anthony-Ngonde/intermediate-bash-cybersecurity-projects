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

most_active_ips

404_errors
