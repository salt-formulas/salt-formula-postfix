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
