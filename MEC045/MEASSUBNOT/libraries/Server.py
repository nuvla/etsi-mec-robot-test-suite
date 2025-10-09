#!/usr/bin/python3
# filepath: c:\Users\Ikram Laptop\ROBOT-Framework\gs032p3-robot-test-suite\MEC048\MEO\CSE\libraries\Server.py

from http.server import BaseHTTPRequestHandler, HTTPServer
import json, os
import logging

# Library version
__version__ = '0.0.1'

class Server(object):
    ROBOT_LIBRARY_VERSION = '0.0.1'

    def spawn_web_server(self, host="127.0.0.1", port=8080, timeout=15, method="POST", endpoint="/callback_url", resp_body=None):
        
        class POST_Server(BaseHTTPRequestHandler):
            def __call__(self, *args, **kwargs):
                """Handle a request."""
                super().__init__(*args, **kwargs)

            def __init__(self, endpoint, resp_body):
                self.resp_body = resp_body
                self.endpoint = endpoint
                self.req_body = None

            def do_POST(self):
                self.send_response(200)
                self.send_header('Content-Type', 'application/json')
                self.end_headers()
                
                content_len = int(self.headers.get('Content-Length'))
                post_body = self.rfile.read(content_len)
                self.req_body = post_body
                logging.info(f"Received notification: {post_body}")

            def get_req_body(self):
                return self.req_body

            def get_resp_body(self):
                return self.resp_body

        self.handler = POST_Server(endpoint, resp_body)
        self.app = HTTPServer((host, int(port)), self.handler)
        self.app.timeout = int(timeout)
        
        logging.info(f"Starting notification server on {host}:{port} with timeout {timeout}")
        self.app.handle_request()
        self.app.server_close()
        
        if self.handler.get_req_body() is not None:
            return json.loads(self.handler.get_req_body().decode("utf-8"))
        return None