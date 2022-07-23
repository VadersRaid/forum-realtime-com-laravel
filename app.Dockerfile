FROM shakshane/laravel-php:latest

COPY composer.lock composer.json /var/www

COPY database /var/www/database

WORKDIR /var/www

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
&& php -r "if (hash_file('sha384', 'composer-setup.php') === '55ce33d7678c5a611085589f1f3ddf8b3c52d662cd01d4ba75c0ee0459970c2200a51f492d557530c71c15d8dba01eae') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
&& php composer-setup.php \
&& php -r "unlink('composer-setup.php');" \
&& php compose.phar install --no-dev --no-scripts \
&& rm compose.phar

COPY . /var/www

RUN  chown -R www-data:www-data \
     /var/www/storage \
     /var/www/bootstrap/cache
RUN php artisan key:generate
RUN php artisan config:cache
RUN php artisan optimize
