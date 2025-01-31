##Docker file containing the environment for running robot3.1 based on python3.9
## As example, MEC016 test suite are used
##How to run this container.

## Build the image using this docker file, make sure the server side is up and running and eventually run the tests.

FROM python:3.10-slim

RUN addgroup robot && adduser -D -G robot -h /home/robot robot
WORKDIR /home/robot

# Install system packages
RUN apt-get update && apt-get install -y \
    build-essential \
    libssl-dev \
    libffi-dev

COPY requirements.txt .
RUN pip install -r requirements.txt

COPY libraries libraries
