FROM mysql

ENV MYSQL_ROOT_PASSWORD 123qwerR
COPY ./create-local-db.sql /tmp
EXPOSE 3306
CMD [ "mysqld", "--init-file=/tmp/create-local-db.sql" ]
