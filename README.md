# Introduction

## What is the image?
PHP's development docker   
Note:this Image is only for PHP. If you need a web server, please use a product that supports php-fpm. For example, [nginx](https://hub.docker.com/_/nginx).

## Quick reference
- Maintained by [JiangZH](https://github.com/j511002/develop-php)
- Base image from [php](https://hub.docker.com/_/php)

## How to use this image
For basic usage, you can refer to the php official image documentation(https://hub.docker.com/_/php).   
You can use composer in this image.

### Default code location
>/var/www/html

### Extensions installed
This image has the following PHP extensions installed:
- bcmath
- gd
- pdo_mysql
- redis
- xdebug
- zip

### Environment
The environment variables that this image can use are as follows:
- ENV XDEBUG_IDEKEY PHPSTORM
- ENV XDEBUG_PORT 9001
- ENV XDEBUG_HOST docker.for.mac.localhost
- ENV XDEBUG_REMOTE_LOG /var/logs/php/xdebug/remote.log
- ENV XDEBUG_PROFILER_ENABLE_TRAIGGER 1
- ENV XDEBUG_PROFILER_OUTPUT_DIR /var/logs/php/xdebug/xdebug_profiler
- ENV XDEBUG_TRACE_OUTPUT_DIR /var/logs/php/xdebug/xdebug_trace

### Custom php.ini
You can get a default php.ini like this:`docker cp mycontainer:/usr/local/etc/php/php.ini /xxx/xxx/`.
After the modification,please replace the `/usr/local/etc/php/php.ini` file in the image.If you use the docker-compose,you can do like this:
```
...
    php:
        volumes:
            - ./php/php.ini:/usr/local/etc/php/php.ini:ro
...
```

## License
You can use this image freely under the premise of observing the license contained in the [php image](https://www.php.net/license/) and [the repo-info repository's php/ directory](https://github.com/docker-library/repo-info/tree/master/repos/php).
