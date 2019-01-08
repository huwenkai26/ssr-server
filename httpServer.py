from BaseHTTPServer import HTTPServer, BaseHTTPRequestHandler
from SocketServer import ThreadingMixIn
import os
import time
import sys
import threading
# curl http://pv.sohu.com/cityjson?ie=utf-8
class Handler(BaseHTTPRequestHandler):

    def do_GET(self):
        host = sys.argv[1]
        port = sys.argv[2]
        self.send_response(200)
        self.end_headers()
        cmd_adsl = 'ssh root@'+host +' -p '+port+'\" adsl-stop;adsl start\"'
        os.system(cmd_adsl)
        time.sleep(4)
        cmd_curl ='ssh root@'+host +' -p '+port+'\" curl  ipinfo.io/ip\"'
        print cmd_curl
        out = os.popen('ssh root@'+host +' -p '+port+'\" curl  ipinfo.io/ip\"')
        message = out.read();
        self.wfile.write(message)
        self.wfile.write('\n')
        return

class ThreadedHTTPServer(ThreadingMixIn, HTTPServer):
    """Handle requests in a separate thread."""

if __name__ == '__main__':
    server = ThreadedHTTPServer(('0.0.0.0', 8888), Handler)
    print 'Starting server, use <Ctrl-C> to stop'
    server.serve_forever()