FROM progrium/busybox:latest

MAINTAINER Sergyi Kukharyev <sergej.kucharev@gmail.com>

ARG user=nginx
ARG group=${user}
RUN adduser -s /bin/false -D ${user} ${group}

RUN opkg-install opkg && opkg update
RUN opkg install vim
RUN opkg install htop

RUN mkdir -pv -m a+r,a+x,u+w /etc/nginx/ /var/lib/nginx/ /var/log/nginx/
RUN mkdir -pv -m a+r,a+x,u+w /data/default/etc/ /data/default/log/ /data/default/www/
RUN opkg install nginx
COPY docker/nginx/etc/nginx.conf /etc/nginx/nginx.conf
COPY docker/nginx/vhost/etc/default.conf /data/default/etc/vhost.conf

RUN mkdir -pv -m a+r,a+x,u+w /docker /docker/nginx/
COPY docker/nginx/watcher.sh /docker/nginx/watcher.sh
COPY docker/enterpoint.sh /docker/enterpoint.sh
RUN chmod -R +x /docker/*.sh
RUN ln -s /docker/enterpoint.sh /bin/enterpoint
RUN ln -s /docker/nginx/watcher.sh /bin/nginx-watcher

#USER ${user}
#RUN opkg install bash
#RUN opkg install nano
#RUN opkg install node
#RUN mkdir -pv -m a+r,a+x,u+w /etc/init.d/ /etc/rc.common/ /etc/shells/
#VOLUME ["/data"]

ENTRYPOINT ["/docker/enterpoint.sh"]
EXPOSE 80 443
