{% from "postfix/map.jinja" import relay with context %}

{%- if relay.enabled %}

include:
- postfix.common

{%- if relay.sasl is defined %}

postfix_sasl_passwd:
  file.managed:
  - name: /etc/postfix/sasl_passwd
  - source: salt://postfix/files/sasl_passwd
  - mode: 600
  - template: jinja
  - require:
    - pkg: postfix_packages
  - watch_in:
    - cmd: postfix_sasl_postmap

postfix_sasl_postmap:
  cmd.wait:
  - name: postmap hash:/etc/postfix/sasl_passwd
  - refreshonly: true
  - require:
    - pkg: postfix_packages
    - file: postfix_sasl_passwd
  - require_in:
    - service: postfix_service

{%- endif %}

{%- endif %}
