#!/usr/bin/python3

from http.server import BaseHTTPRequestHandler, HTTPServer
import json, os
import logging

# Library version
__version__ = '0.0.1'

def import_notification_json(subscription_type):
    notification_type = subscription_type.split("Subscription")[0]    
    file_path = "./jsons/"+notification_type+".json"
    logging.info(file_path)
    logging.info(os.listdir())
    try:
        with open(file_path, 'r') as json_file:
            # Load the JSON data
            data = json.load(json_file)
            logging.info(data)
            return data
    except FileNotFoundError:
        logging.error(f"Error: File not found at {file_path}")


class Server ( object ):

    ROBOT_LIBRARY_VERSION = '0.0.1'

    def spawn_web_server (self, host="127.0.0.1", port=8080, timeout=15, method="POST", endpoint="/callback_url", resp_body=None):
        
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
                self.req_body = None
                

            def do_POST(self):
                self.send_response(200)
                self.send_header('Content-Type', 'application/json')
                self.end_headers()
                
                #if self.path == self.endpoint:
                #    self.wfile.write(json.dumps(self.resp_body).encode(encoding='utf_8'))
                #else:
                #    self.wfile.write(json.dumps("wrong endpoint").encode(encoding='utf_8'))
                
                content_len = int(self.headers.get('Content-Length'))
                post_body = self.rfile.read(content_len)
                self.req_body=post_body

            def get_req_body(self):
                return self.req_body

            def get_resp_body(self):
                return self.resp_body
 

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
            logging.info("Error, unknown endpoint")
            exit(1)
        
        self.app = HTTPServer((host, int(port)), self.handler)
        self.app.timeout = int(timeout)
        

        self.app.handle_request()
        self.app.server_close()
        logging.info(self.handler.get_resp_body())
        if(self.handler.get_req_body()!=None):
            return json.loads(self.handler.get_req_body().decode("windows-1252"))
        notification_json= import_notification_json(self.handler.get_resp_body())
        return notification_json
        
