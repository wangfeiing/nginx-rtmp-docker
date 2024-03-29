FROM centos:latest AS builder

RUN yum -y upgrade 

RUN yum install -y perl-ExtUtils-Embed readline-devel zlib-devel pam-devel libxml2-devel libxslt-devel openldap-devel  gcc-c++ openssl-devel  nano   gcc gcc-c++ ncurses-devel perl
RUN yum install -y python36  cmake pcre-devel 
RUN mkdir -p /usr/local/nginx

WORKDIR /usr/local/nginx
RUN mkdir -p /usr/local/nginx/nginx-src
COPY ./nginx-1.20.0 ./nginx-src
COPY ./nginx-rtmp-module ./nginx-rtmp-module

WORKDIR /usr/local/nginx/nginx-src

RUN ./configure --add-module=/usr/local/nginx/nginx-rtmp-module --with-http_ssl_module
RUN make && make install
COPY ./conf /usr/local/nginx/conf 

#  运行环境
FROM centos:latest

COPY --from=builder  /usr/local/nginx /usr/local/nginx
RUN ln -s /usr/local/nginx/sbin/nginx /usr/bin/nginx
WORKDIR /usr/local/nginx
CMD ["/usr/bin/nginx"]