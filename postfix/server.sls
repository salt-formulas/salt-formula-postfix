{% from "postfix/map.jinja" import server with context %}

{%- if server.enabled %}

include:
- postfix.common

postfix_mysql_virtual_alias:
  file.managed:
  - name: /etc/postfix/mysql_virtual_alias_maps.cf
  - source: salt://postfix/files/sql/mysql_virtual_alias_maps.cf
  - mode: 440
  - user: postfix
  - group: postfix
  - template: jinja
  - require:
    - pkg: postfix_packages
  - watch_in:
    - service: postfix_service

postfix_mysql_virtual_mailbox:
  file.managed:
  - name: /etc/postfix/mysql_virtual_mailbox_maps.cf
  - source: salt://postfix/files/sql/mysql_virtual_mailbox_maps.cf
  - mode: 440
  - user: postfix
  - group: postfix
  - template: jinja
  - require:
    - pkg: postfix_packages
  - watch_in:
    - service: postfix_service

postfix_mysql_virtual_domains:
  file.managed:
  - name: /etc/postfix/mysql_virtual_domains_maps.cf
  - source: salt://postfix/files/sql/mysql_virtual_domains_maps.cf
  - mode: 440
  - user: postfix
  - group: postfix
  - template: jinja
  - require:
    - pkg: postfix_packages
  - watch_in:
    - service: postfix_service

{%- endif %}
