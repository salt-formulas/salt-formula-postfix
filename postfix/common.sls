{% from "postfix/map.jinja" import server, relay with context %}

postfix_packages:
  pkg.installed:
    - names: {{ server.pkgs }}
    - watch_in:
      service: postfix_service

postfix_service:
  service.running:
    - name: {{ server.service }}
    - require:
      - file: postfix_main_config

{%- for chroot_file in server.chroot_files %}

/var/spool/postfix/{{ chroot_file }}:
  file.copy:
    - source: {{ chroot_file }}
    - preserve: true
    - makedirs: true
    - watch_in:
      - service: postfix_service
    - require:
      - pkg: postfix_packages

{%- endfor %}

postfix_main_config:
  file.managed:
  - name: /etc/postfix/main.cf
  - source: salt://postfix/files/main.cf
  - mode: 644
  - template: jinja
  - require:
    - pkg: postfix_packages
  - watch_in:
    - service: postfix_service

postfix_master_config:
  file.managed:
  - name: /etc/postfix/master.cf
  - source: salt://postfix/files/master.cf
  - template: jinja
  - require:
    - pkg: postfix_packages
  - watch_in:
    - service: postfix_service

postfix_aliases:
  file.managed:
  - name: /etc/aliases
  - source: salt://postfix/files/aliases
  - template: jinja
  - require:
    - pkg: postfix_packages

/var/lib/mailman/data:
  file.directory:
  - makedirs: True
  - user: list
  - group: list
  - mode: 770

/var/lib/mailman/data/aliases:
  file.symlink:
  - target: /etc/aliases

postfix_newaliases:
  cmd.wait:
  - name: newaliases
  - watch:
    - file: postfix_aliases
  - require:
    - file: /var/lib/mailman/data

{%- if grains.os_family == 'Debian' %}

/etc/mailname:
  file.managed:
  - contents: {{ server.myorigin }}

{%- endif %}

{%- if server.get('ssl', {}).get('enabled', False) %}

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
