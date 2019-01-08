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
check_port() {
        echo "Checking instance port ..."
       lsof -i :"$1"
}

while true
    do
    echo "Please enter password for host:"
    read -p "请输入服务器ip :" host
    if  [ ! -n "$host" ] ;then
        echo -e "[${red}Error${plain}] 请输入ip"
        continue
    fi

    echo
    echo "---------------------------"
    echo  host = ${host}
    echo "---------------------------"
    echo
    break
done
while true
    do
    echo "ssh 端口:"
    read -p "ssh端口号 :" port
    if  [ ! -n "$port" ] ;then
        echo -e "[${red}Error${plain}] 请输入端口号"
        continue
    fi

    echo
    echo "---------------------------"
    echo  port = ${port}
    echo "---------------------------"
    echo
    break
done
#将私钥上传至服务器
ssh-copy-id -i ~/.ssh/id_rsa.pub root@${host} -p ${port}

if ! check_port 8888
then
   nohup  python httpServer.py ${host} ${port} > /dev/null 2>&1 &
fi

git clone https://github.com/huwenkai26/ssr-server.git
cd ssr-server
rm -rf .git
cd ..
ssh root@${host}  -p ${port}  "sh env.sh"
scp -P  ${port}  -r ssr-server root@${host}:~/
rm -rf ssr-server
ssh root@${host}  -p ${port}  "cd ~/;ssr-server/ss-fly.sh -ssr"
