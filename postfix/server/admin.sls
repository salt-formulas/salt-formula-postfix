{% from "postfix/map.jinja" import server with context %}

{%- if server.admin.enabled %}

postfixadmin_packages:
  pkg.installed:
    - names:
      - postfixadmin
      - php5-imap

postfixadmin_dbconfig:
  file.managed:
  - name: /etc/postfixadmin/dbconfig.inc.php
  - source: salt://postfix/files/admin/dbconfig.inc.php
  - mode: 640
  - user: root
  - group: www-data
  - template: jinja
  - require:
    - pkg: postfixadmin_packages

postfixadmin_config:
  file.managed:
  - name: /etc/postfixadmin/config.local.php
  - source: salt://postfix/files/admin/config.local.php
  - template: jinja
  - require:
    - pkg: postfixadmin_packages

{%- endif %}
