from BaseHTTPServer import HTTPServer, BaseHTTPRequestHandler
from SocketServer import ThreadingMixIn
import os
import time
import sys
import urlparse


# curl http://pv.sohu.com/cityjson?ie=utf-8
class Handler(BaseHTTPRequestHandler):

    def do_GET(self):
        self.send_response(200)
        self.end_headers()
        url_path = self.path.__str__();
        print url_path
        url_path = url_path[url_path.find('?') + 1:url_path.__len__()]
        qs = dict((k, v if len(v) > 1 else v[0])
                  for k, v in urlparse.parse_qs(url_path).iteritems())

        port = qs.get('port')
        host = qs.get('host')
        print port
        print host
        if (None is port) or (None is host):
            self.send_response(500)
            return
        cmd_adsl = 'ssh root@' + host + ' -p ' + port + ' \" adsl-stopt\"'
        print cmd_adsl
        os.system(cmd_adsl)
        time.sleep(2)
        cmd_adsl = 'ssh root@' + host + ' -p ' + port + ' \" adsl-start\"'
        print cmd_adsl
        os.system(cmd_adsl)
        cmd_curl = 'ssh root@' + host + ' -p ' + port + ' \" curl  ipinfo.io/ip\"'
        print cmd_curl
        time.sleep(4)
        out = os.popen('ssh root@' + host + ' -p ' + port + '  \" curl  ipinfo.io/ip\"')
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
