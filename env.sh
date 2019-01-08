#!/usr/bin bash
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
             apt-get  install -y wget
             ;;
        'centos')
             yum install -y wget
             ;;
esac

wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-6.repo
check_os
case $os in
        'ubuntu'|'debian')
     apt-get -y update
             apt-get  clean all
             apt-get  makecache
             apt-get  install -y openssh-clients
             ;;
        'centos')
             yum clean all
             yum makecache
             yum install -y openssh-clients
             ;;
esac
