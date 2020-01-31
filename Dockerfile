FROM debian:buster
COPY srcs/index.html ./root/
COPY srcs/config.inc.php ./root/
COPY srcs/nginx.conf ./root/
COPY srcs/wp-config.php ./root/
COPY srcs/start.sh ./
CMD bash start.sh && sleep infinity && wait
