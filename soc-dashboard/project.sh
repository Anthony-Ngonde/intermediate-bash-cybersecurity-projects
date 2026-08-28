#!/usr/bin/bash

echo "==============================="
echo "SOC Monitoring and Alert System"
echo "==============================="


failed_ssh_logins() {

echo "================="
echo "Failed SSH Logins"
echo "================="

sudo journalctl -u ssh |
grep "Failed password"


}

failed_ssh_logins


