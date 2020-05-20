FROM php:7.4.5-fpm-alpine
LABEL Maintainer="JiangZH <j5110021@gmail.com>" \
      Description="PHP-FPM 7.4.5 on Alpine Linux .  "

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
# RUN cp "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"