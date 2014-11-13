FROM phusion/baseimage:0.9.15
MAINTAINER Brian Prodoehl <bprodoehl@connectify.me>

ENV HOME=/root
CMD ["/sbin/my_init"]
EXPOSE 80

RUN echo "deb http://ppa.launchpad.net/nginx/stable/ubuntu $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/nginx-stable.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys C300EE8C
RUN apt-get update -q && \
    apt-get install -qy nginx php5-gd php5-fpm php5-json php5-mysql php5-curl \
                        wget && \
    apt-get cleanup

RUN mkdir /etc/service/nginx
ADD runit/nginx.sh /etc/service/nginx/run

RUN mkdir /etc/service/php5-fpm
ADD runit/php5-fpm.sh /etc/service/php5-fpm/run

ADD config/nginx.conf /etc/nginx/nginx.conf
ADD config/nginx-default.conf /etc/nginx/sites-available/default
ADD config/php.ini /etc/php5/fpm/php.ini

RUN cd /var/www/html && \
    wget http://builds.piwik.org/piwik-2.9.0.tar.gz && \
    tar -xzf piwik-2.9.0.tar.gz && \
    rm piwik-2.9.0.tar.gz && \
    mv piwik/* . && \
    rm -r piwik && \
    chmod a+w /var/www/html/tmp && \
    chmod a+w /var/www/html/config && \
    rm /var/www/html/index.html

RUN mkdir /etc/service/httpd
ADD runit/httpd.sh /etc/service/httpd/run
