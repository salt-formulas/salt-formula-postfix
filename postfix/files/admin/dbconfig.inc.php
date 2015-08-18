{%- from "postfix/map.jinja" import server with context %}
dbuser='{{ server.mysql.user }}'
dbpass='{{ server.mysql.password }}'
basepath=''
dbname='{{ server.mysql.database }}'
dbserver='{{ server.mysql.host }}'
dbport='3306'
dbtype='mysql'
