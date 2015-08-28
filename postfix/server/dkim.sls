{% from "postfix/map.jinja" import server with context %}

{%- if server.dkim.enabled %}

dkim_packages:
  pkg.installed:
    - names: {{ server.pkgs_dkim }}

dkim_config:
  file.managed:
  - name: /etc/opendkim.conf
  - source: salt://postfix/files/dkim/opendkim.conf
  - template: jinja
  - require:
    - pkg: dkim_packages
  - watch_in:
    - service: dkim_service

dkim_dir:
  file.directory:
    - name: /etc/opendkim
    - mode: 750
    - group: opendkim
    - require:
      - pkg: dkim_packages

dkim_keys_dir:
  file.directory:
    - name: /etc/opendkim/keys
    - mode: 750
    - group: opendkim
    - require:
      - file: dkim_dir

dkim_service:
  service.running:
  - name: {{ server.service_dkim }}
  - require:
    - file: dkim_config

dkim_trustedhosts:
  file.managed:
  - name: /etc/opendkim/TrustedHosts
  - source: salt://postfix/files/dkim/TrustedHosts
  - template: jinja
  - require:
    - file: dkim_dir
  - require_in:
    - file: dkim_config

dkim_keytable:
  file.managed:
  - name: /etc/opendkim/KeyTable
  - source: salt://postfix/files/dkim/KeyTable
  - template: jinja
  - require:
    - file: dkim_dir
  - require_in:
    - file: dkim_config

dkim_signingtable:
  file.managed:
  - name: /etc/opendkim/SigningTable
  - source: salt://postfix/files/dkim/SigningTable
  - template: jinja
  - require:
    - file: dkim_dir
  - require_in:
    - file: dkim_config

{%- if server.dkim.domains is defined %}
{%- for domain in server.dkim.domains %}

dkim_{{ domain.name }}_key:
  file.managed:
  - name: /etc/opendkim/keys/{{ domain.name }}.private
  - source: salt://postfix/files/dkim/private_key
  - template: jinja
  - defaults:
      domain_name: {{ domain.name }}
  - group: opendkim
  - mode: 640
  - require:
    - file: dkim_keys_dir
  - require_in:
    - file: dkim_keytable

{%- endfor %}
{%- endif %}

{%- endif %}
