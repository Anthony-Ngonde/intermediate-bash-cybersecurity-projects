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


#operating_system

kernel_version
