FROM ubuntu:16.04

MAINTAINER ETSI STF 569

LABEL description="SFT569 Robot Framework Docker Image"

ENV TERM=xterm
ENV HOSTNAME docker-robot-STF569


ARG ssh_prv_key



RUN DEBIAN_FRONTEND=noninteractive apt update \
	&& apt install python3  git -y \
	&& apt install python3-pip -y \
        && apt install openssh-server -y \
    && DEBIAN_FRONTEND=noninteractive apt-get autoremove --purge -y \
    && DEBIAN_FRONTEND=noninteractive apt-get autoclean \
    && rm -rf /var/lib/apt/lists/*


RUN echo "docker-robot-STF569" > /etc/hostname \
    && echo "root:etsi" | chpasswd

RUN useradd --create-home --shell /bin/bash --user-group etsi --groups sudo \
    && echo "etsi:etsi" | chpasswd \
    && adduser etsi sudo \
    && echo "etsi ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers


RUN DEBIAN_FRONTEND=noninteractive \
        && mkdir -p /home/etsi/dev/robot \
        && cd /home/etsi/dev/robot 


ADD . /home/etsi/dev/robot

RUN pip3 install robotframework

RUN DEBIAN_FRONTEND=noninteractive \
	&& cd /home/etsi/dev/robot \
	&& pip3 install -r requirements.txt \
	&& chmod +x /home/etsi/dev/robot/scripts/* 

CMD tail -f /dev/null


