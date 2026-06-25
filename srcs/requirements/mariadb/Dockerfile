FROM debian:bookworm

RUN apt-get update && apt-get install -y mariadb-server && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /var/run/mysqld \
    && chown -R mysql:mysql /var/run/mysqld \
    && chmod 777 /var/run/mysqld

COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY tools/mariadb_start.sh /usr/local/bin/mariadb_start.sh
RUN chmod +x /usr/local/bin/mariadb_start.sh

EXPOSE 3306

ENTRYPOINT ["/usr/local/bin/mariadb_start.sh"]
