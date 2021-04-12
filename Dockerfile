ARG PHP_VERSION=7.3

FROM devilster/base-php-apache2:${PHP_VERSION}

LABEL maintainer="Devil.Ster.1"
LABEL version="1.0.1"

ARG BUILD_VER=20201025
ARG PHP_VERSION=${PHP_VERSION}


# START PHP Configuration
RUN cp /usr/local/etc/php/php.ini-development /usr/local/etc/php/php.ini

RUN sed -e 's/;error_log = php_errors.log/error_log = \/var\/log\/apache2\/php_error.log/' -i /usr/local/etc/php/php.ini
RUN sed -e 's/display_errors = Off/display_errors = On/' -i /usr/local/etc/php/php.ini
RUN sed -e 's/display_startup_errors = Off/display_startup_errors = On/' -i /usr/local/etc/php/php.ini

# END PHP Configuration

# START Install XDebug Support
RUN apt-get update && apt-get install -y --no-install-recommends \
    --allow-downgrades --allow-remove-essential --allow-change-held-packages \
        \
    && pecl install xdebug \
    && docker-php-ext-enable xdebug \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN echo "xdebug.remote_enable=1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.remote_autostart=1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.remote_handler=dbgp" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.remote_connect_back = 0" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.remote_port=9000" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.remote_mode=req" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.idekey=\"PHPSTORM\"" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
# END Install XDebug Support

EXPOSE 80
EXPOSE 443