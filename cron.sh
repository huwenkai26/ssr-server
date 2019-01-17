#!/usr/bin bash

check_port() {
        echo "Checking instance port ..."
       lsof -i :"$1"
}
if ! check_port 8888
then
   nohup  python httpServer.py  > /dev/null 2>&1 &
fi