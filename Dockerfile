FROM centos:latest
MAINTAINER madebymode

RUN rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
RUN rpm -Uvh https://centos7.iuscommunity.org/ius-release.rpm

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
    && yum clean all && yum history new

RUN sed -e 's/127.0.0.1:9000/9000/' \
        -e '/allowed_clients/d' \
        -e '/catch_workers_output/s/^;//' \
        -e '/error_log/d' \
        -i /etc/php-fpm.d/www.conf

CMD ["php-fpm", "-F"]

EXPOSE 9000
