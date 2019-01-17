#!/usr/bin bash

check_port() {
        echo "Checking instance port ..."
       lsof -i :"$1"
}
if ! check_port 8888
then
   echo "开启服务"
   nohup  python /home/liu/ssr-server/httpServer.py >/home/liu/ssr-server/nohup.out  2>&1 &
fi
