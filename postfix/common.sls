{% from "postfix/map.jinja" import server with context %}

postfix_packages:
  pkg.installed:
    - names: {{ server.pkgs }}
    - watch_in:
      service: postfix_service

postfix_service:
  service.running:
    - name: {{ server.service }}
    - require:
      - pkg: postfix_packages
