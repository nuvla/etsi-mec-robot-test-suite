#!/usr/bin/python3

from http.server import BaseHTTPRequestHandler, HTTPServer
import json

# Library version
__version__ = '0.0.1'

class Server ( object ):

    ROBOT_LIBRARY_VERSION = '0.0.1'

    def spawn_web_server (self, host, port, timeout, method, endpoint, resp_body):
        
        class GET_Server(BaseHTTPRequestHandler):

            def __call__(self, *args, **kwargs):
                """Handle a request."""
                super().__init__(*args, **kwargs)
            
            def __init__(self, endpoint, resp_body):
                self.resp_body = resp_body
                self.endpoint = endpoint

            def do_GET(self):
                self.send_response(200)
                self.send_header('Content-Type', 'application/json')
                self.end_headers()
                if self.path == self.endpoint:
                    self.wfile.write(json.dumps(self.resp_body).encode(encoding='utf_8'))
                else:
                    self.wfile.write(json.dumps("wrong endpoint").encode(encoding='utf_8'))

        class POST_Server(BaseHTTPRequestHandler):

            def __call__(self, *args, **kwargs):
                """Handle a request."""
                super().__init__(*args, **kwargs)

            def __init__(self, endpoint, resp_body):
                self.resp_body = resp_body
                self.endpoint = endpoint

            def do_POST(self):
                self.send_response(200)
                self.send_header('Content-Type', 'application/json')
                self.end_headers()
                if self.path == self.endpoint:
                    self.wfile.write(json.dumps(self.resp_body).encode(encoding='utf_8'))
                else:
                    self.wfile.write(json.dumps("wrong endpoint").encode(encoding='utf_8'))

        class PUT_Server(BaseHTTPRequestHandler):

            def __call__(self, *args, **kwargs):
                """Handle a request."""
                super().__init__(*args, **kwargs)

            def __init__(self, endpoint, resp_body):
                self.resp_body = resp_body
                self.endpoint = endpoint

            def do_PUT(self):
                self.send_response(200)
                self.send_header('Content-Type', 'application/json')
                self.end_headers()
                if self.path == self.endpoint:
                    self.wfile.write(json.dumps(self.resp_body).encode(encoding='utf_8'))
                else:
                    self.wfile.write(json.dumps("wrong endpoint").encode(encoding='utf_8'))
        
        class DELETE_Server(BaseHTTPRequestHandler):

            def __call__(self, *args, **kwargs):
                """Handle a request."""
                super().__init__(*args, **kwargs)

            def __init__(self, endpoint, resp_body):
                self.resp_body = resp_body
                self.endpoint = endpoint

            def do_DELETE(self):
                self.send_response(200)
                self.send_header('Content-Type', 'application/json')
                self.end_headers()
                if self.path == self.endpoint:
                    self.wfile.write(json.dumps(self.resp_body).encode(encoding='utf_8'))
                else:
                    self.wfile.write(json.dumps("wrong endpoint").encode(encoding='utf_8'))

        if method == "GET":
            self.handler = GET_Server(endpoint, resp_body)
        elif method == "POST":
            self.handler = POST_Server(endpoint, resp_body)
        elif method == "PUT":
            self.handler = PUT_Server(endpoint, resp_body)
        elif method == "DELETE":
            self.handler = DELETE_Server(endpoint, resp_body)
        else:
            print("Error, unknown endpoint")
            exit(1)
        
        self.app = HTTPServer((host, int(port)), self.handler)
        self.app.timeout = int(timeout)
        
        self.app.handle_request()
        self.app.server_close()