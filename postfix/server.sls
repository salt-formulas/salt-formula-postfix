{% from "postfix/map.jinja" import server with context %}

{%- if server.enabled %}

include:
- postfix.common
- postfix.server.admin
- postfix.server.dkim
- postfix.server.mailman

postfix_master_config:
  file.managed:
  - name: /etc/postfix/master.cf
  - source: salt://postfix/files/master.cf
  - template: jinja
  - require:
    - pkg: postfix_packages
  - watch_in:
    - service: postfix_service

{%- if not salt['user.info'](server.user.name) %}
user_vmail:
  user.present:
  - name: {{ server.user.name }}
  - home: {{ server.user.home }}
  - shell: /bin/false
  - uid: {{ server.user.uid }}
  - gid: {{ server.user.gid }}
  - system: True
  - groups:
    - {{ server.user.group }}
  - require_in:
    - service: postfix_packages

group_vmail:
  group.present:
    - name: {{ server.user.group }}
    - gid: {{ server.user.gid }}
    - system: True
    - require_in:
      - user: user_vmail
{%- endif %}

{%- if grains.os_family == 'Debian' %}

/etc/mailname:
  file.managed:
  - contents: {{ server.myorigin }}

{%- endif %}

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

postfix_mysql_virtual_alias_domains:
  file.managed:
  - name: /etc/postfix/mysql_virtual_alias_domains_maps.cf
  - source: salt://postfix/files/sql/mysql_virtual_alias_domains_maps.cf
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

postfix_mysql_relay_domains:
  file.managed:
  - name: /etc/postfix/mysql_relay_domains_maps.cf
  - source: salt://postfix/files/sql/mysql_relay_domains_maps.cf
  - mode: 440
  - user: postfix
  - group: postfix
  - template: jinja
  - require:
    - pkg: postfix_packages
  - watch_in:
    - service: postfix_service

postfix_mysql_virtual_alias_domain_catchall_maps:
  file.managed:
  - name: /etc/postfix/mysql_virtual_alias_domain_catchall_maps.cf
  - source: salt://postfix/files/sql/mysql_virtual_alias_domain_catchall_maps.cf
  - mode: 440
  - user: postfix
  - group: postfix
  - template: jinja
  - require:
    - pkg: postfix_packages
  - watch_in:
    - service: postfix_service

postfix_mysql_virtual_mailbox_limit:
  file.managed:
  - name: /etc/postfix/mysql_virtual_mailbox_limit_maps.cf
  - source: salt://postfix/files/sql/mysql_virtual_mailbox_limit_maps.cf
  - mode: 440
  - user: postfix
  - group: postfix
  - template: jinja
  - require:
    - pkg: postfix_packages
  - watch_in:
    - service: postfix_service

{%- if server.ssl.get('enabled', False) %}

/etc/postfix/ssl:
  file.directory:
  - user: root
  - group: postfix
  - mode: 750
  - require:
    - pkg: postfix_packages

/etc/postfix/ssl/{{ server.origin }}.crt:
  file.managed:
  - source: salt://postfix/files/ssl_cert_all.crt
  - template: jinja
  - user: root
  - group: postfix
  - mode: 640
  - require:
    - file: /etc/postfix/ssl
  - watch_in:
    - service: postfix_service

/etc/postfix/ssl/{{ server.origin }}.key:
  file.managed:
  - contents_pillar: postfix:server:ssl:key
  - user: root
  - group: postfix
  - mode: 640
  - require:
    - file: /etc/postfix/ssl
  - watch_in:
    - service: postfix_service

{%- endif %}

{%- endif %}
