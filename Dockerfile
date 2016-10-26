FROM ubuntu:trusty

ENV DEBIAN_FRONTEND noninteractive
ENV PATH $PATH:/usr/local/nginx/sbin

EXPOSE 1935
EXPOSE 80

RUN mkdir /src && mkdir /config && mkdir /logs && mkdir /data && mkdir /static

RUN apt-get update && apt-get upgrade -y && apt-get clean
RUN apt-get install -y build-essential libpcre3-dev zlib1g-dev libssl-dev wget software-properties-common

RUN add-apt-repository ppa:mc3man/trusty-media && apt-get update
RUN apt-get install -y ffmpeg

RUN cd /src && wget http://nginx.org/download/nginx-1.10.2.tar.gz && tar zxf nginx-1.10.2.tar.gz && rm nginx-1.10.2.tar.gz

# get nginx-rtmp module
RUN cd /src && wget https://github.com/arut/nginx-rtmp-module/archive/master.zip && unzip master.zip && rm master.zip

# compile nginx
RUN cd /src/nginx-1.10.2 && ./configure --add-module=/src/nginx-rtmp-module-master --conf-path=/config/nginx.conf --error-log-path=/logs/error.log --http-log-path=/logs/access.log
RUN cd /src/nginx-1.10.2 && make && make install

ADD nginx.conf /config/nginx.conf

ENTRYPOINT "nginx"