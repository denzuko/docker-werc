
FROM httpd:latest
ARG DEBIAN_FRONTEND=noninteractive 
ARG VHOST=example.com
ENV HOSTNAME $VHOST
ENV HTTPD_PREFIX /usr/local/apache2
ENV PATH $PATH:$HTTPD_PREFIX/bin
COPY ./werc-apache.conf /usr/local/apache2/conf/httpd.conf
RUN apt-get update && \
    apt-get install -qq -y wget 9base libtext-markdown-perl imagemagick && \
    wget --no-check-certificate http://werc.cat-v.org/download/werc-1.5.0.tar.gz -O /tmp/werc.tgz && \
    tar zxvf /tmp/werc.tgz -C /var/ && \
    mv /var/werc* /var/werc && \
    sed -i'' 's#$PLAN9#/usr/lib/plan9#g' /var/werc/etc/initrc && \
    mv /var/werc/sites/werc.cat-v.org /var/werc/sites/$HOSTNAME
    ln -s /usr/lib/plan9 /usr/local/plan9 && \
    rm /tmp/werc.tgz && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
CMD ["httpd-foreground"]
