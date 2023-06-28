import logging
logging.basicConfig(format='%(levelname)s:%(message)s', level=logging.DEBUG)
import requests

import swagger_server.controllers.async_task as at

class DummyService:
    def async_task(self, pars):
        notification_url = pars[0]
        data = {}
        data["_links"]={}
        data["_links"]["self"]="XX"
        data["expiryDeadline"]={}
        data["expiryDeadline"]["seconds"]=1234
        data["expiryDeadline"]["nanoseconds"]=1234
        logging.info(notification_url)
        logging.info(data)
        response = requests.post(notification_url, json=data)
        status_code = response.status_code

    def invoke_sth(self,notification_url):
        at.start_workflow(5, self, "async_task", [notification_url])