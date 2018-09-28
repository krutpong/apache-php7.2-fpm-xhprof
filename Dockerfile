FROM krutpong/apache-php7.2-fpm
MAINTAINER krutpong "krutpong@gmail.com"


RUN git clone https://github.com/tideways/php-profiler-extension.git
RUN cd php-profiler-extension && \
    phpize && \
    ./configure && \
    make && \
    make install
RUN echo "extension=tideways_xhprof.so" > /etc/php/7.2/mods-available/tideways_xhprof.ini
RUN phpenmod tideways_xhprof

EXPOSE 80
EXPOSE 443
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

ADD config/index.html /var/www/index.html
ADD config/index.php /var/www/index.php
COPY config/apache2.conf /etc/apache2/apache2.conf

COPY config/apache_enable.sh apache_enable.sh
RUN chmod 744 apache_enable.sh


#VOLUME ["/var/lib/mysql"]
VOLUME ["/var/www","/var/www"]
RUN service php7.2-fpm start
CMD ["/usr/bin/supervisord"]








