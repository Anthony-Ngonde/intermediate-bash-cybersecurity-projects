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


#list_all_users
users_with_login_shells



