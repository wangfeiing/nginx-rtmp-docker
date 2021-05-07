FROM centos:latest

RUN yum -y upgrade 

RUN yum install -y perl-ExtUtils-Embed readline-devel zlib-devel pam-devel libxml2-devel libxslt-devel openldap-devel  gcc-c++ openssl-devel  nano   gcc gcc-c++ ncurses-devel perl
RUN yum install -y python36  cmake pcre-devel 

WORKDIR /root

ADD ./nginx-1.20.0 ./nginx

ADD ./nginx-rtmp-module ./nginx-rtmp-module

WORKDIR /root/nginx 
RUN ./configure --add-module=/root/nginx-rtmp-module --with-http_ssl_module
RUN make && make install
COPY ./conf /usr/local/nginx/conf 
RUN ln -s /usr/local/nginx/sbin/nginx /usr/bin/nginx

CMD ["/usr/bin/nginx"]