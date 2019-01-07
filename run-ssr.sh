#! /bin/bash
check_os() {
    if [[ -f /etc/redhat-release ]]; then
        os="centos"
    elif cat /etc/issue | grep -Eqi "debian"; then
        os="debian"
    elif cat /etc/issue | grep -Eqi "ubuntu"; then
        os="ubuntu"
    elif cat /etc/issue | grep -Eqi "centos|red hat|redhat"; then
        os="centos"
    elif cat /proc/version | grep -Eqi "debian"; then
        os="debian"
    elif cat /proc/version | grep -Eqi "ubuntu"; then
        os="ubuntu"
    elif cat /proc/version | grep -Eqi "centos|red hat|redhat"; then
        os="centos"
    fi
}
check_os
case $os in
        'ubuntu'|'debian')
     apt-get -y update
             apt-get -y install git
             yum update -y nss curl libcurl
             ;;
        'centos')
             yum install -y git
             ;;
esac
git config --global user.name "hwk"
git config --global user.email "huwenkai26@gmail.com"
git clone https://github.com/huwenkai26/ssr-server.git
ssr-server/ss-fly.sh -ssr

