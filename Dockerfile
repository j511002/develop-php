FROM php:7.4.5-fpm-alpine
LABEL Maintainer="JiangZH <j5110021@gmail.com>" \
      Description="PHP-FPM 7.4.5 on Alpine Linux .  "

ENV XDEBUG_IDEKEY PHPSTORM
ENV XDEBUG_PORT 9001
ENV XDEBUG_HOST docker.for.mac.localhost
ENV XDEBUG_REMOTE_LOG /var/logs/php/xdebug/remote.log
ENV XDEBUG_PROFILER_ENABLE_TRAIGGER 1
ENV XDEBUG_PROFILER_OUTPUT_DIR /var/logs/php/xdebug/xdebug_profiler
ENV XDEBUG_TRACE_OUTPUT_DIR /var/logs/php/xdebug/xdebug_trace

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories \ 
    && apk update \
    && apk add --no-cache git libmcrypt-dev freetype-dev libjpeg-turbo-dev libpng-dev libzip-dev \
    # 安装php拓展   
    && docker-php-ext-install pdo_mysql bcmath zip \
    # 配置GD
    && docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/ \
    # 安装GD
    && docker-php-ext-install -j$(nproc) gd \
    # 因为pecl在alpine容器中安装扩展会少一些东西，所以我们先安装了一个phpize_deps，用后删除即可，保持镜像瘦小
    && apk add ${PHPIZE_DEPS} \
    && pecl install redis \
    && pecl install xdebug-2.9.5 \
    && docker-php-ext-enable redis xdebug \
    && apk del ${PHPIZE_DEPS}

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/

# Use the default production configuration
RUN cp "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"
# 写入Xdebug的内容
RUN sed -i "1 a xdebug.idekey=${XDEBUG_IDEKEY}" /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN sed -i "1 a xdebug.remote_autostart=true" /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN sed -i "1 a xdebug.remote_mode=req" /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN sed -i "1 a xdebug.remote_handler=dbgp" /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN sed -i "1 a xdebug.remote_port=${XDEBUG_PORT}" /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN sed -i "1 a xdebug.remote_host=${XDEBUG_HOST}" /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN sed -i "1 a xdebug.remote_enable=on" /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN sed -i "1 a xdebug.remote_log=${XDEBUG_REMOTE_LOG}" /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN sed -i "1 a xdebug.profiler_enable=0" /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN sed -i "1 a xdebug.profiler_enable_trigger=${XDEBUG_PROFILER_ENABLE_TRAIGGER}" /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN sed -i "1 a xdebug.profiler_output_name=cachegrind.out.%t.%p" /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN sed -i "1 a xdebug.profiler_output_dir=${XDEBUG_PROFILER_OUTPUT_DIR}" /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN sed -i "1 a xdebug.trace_output_dir=${XDEBUG_TRACE_OUTPUT_DIR}" /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini