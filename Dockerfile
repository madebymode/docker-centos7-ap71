FROM centos:7
MAINTAINER madebymode

RUN rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
RUN rpm -Uvh https://repo.ius.io/ius-release-el7.rpm
#php71u is archived
RUN yum-config-manager --enable ius-archive

# Update and install latest packages and prerequisites
RUN yum update -y \
    && yum install -y --nogpgcheck --setopt=tsflags=nodocs \
        php71u-cli \
        php71u-common \
        php71u-fpm \
        php71u-gd \
        php71u-mbstring \
        php71u-mysqlnd \
        php71u-xml \
        php71u-json \
        php71u-intl \
        php71u-mcrypt \
        php71u-bcmath \
        zip \
        unzip \
        sendmail \
    && yum clean all && yum history new
    
#composer 1.10
RUN curl -sS https://getcomposer.org/installer | php -- --version=1.10.22 --install-dir=/usr/local/bin --filename=composer
#composer 2
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer2

RUN sed -e 's/127.0.0.1:9000/9000/' \
        -e '/allowed_clients/d' \
        -e '/catch_workers_output/s/^;//' \
        -e '/error_log/d' \
        -i /etc/php-fpm.d/www.conf

CMD ["php-fpm", "-F"]

EXPOSE 9000
