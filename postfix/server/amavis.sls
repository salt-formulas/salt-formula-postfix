{% from "postfix/map.jinja" import server with context %}

{%- if server.amavis.enabled %}

amavis_packages:
  pkg.installed:
    - names: {{ server.pkgs_amavis }}

amavis_service:
{%- if not grains.get('noservices', False) %}
  service.running:
    - name: {{ server.service_amavis }}
    - require:
      - pkg: amavis_packages
{% else %}
  service.disabled:
    - name: {{ server.service_amavis }}
{% endif %}

clamav_service:
{%- if not grains.get('noservices', False) %}
  service.running:
    - name: {{ server.service_clamav }}
    - require:
      - pkg: amavis_packages
{% else %}
  service.disabled:
    - name: {{ server.service_clamav }}
{% endif %}

freshclam_service:
{%- if not grains.get('noservices', False) %}
  service.running:
    - name: {{ server.service_freshclam }}
    - require:
      - pkg: amavis_packages
{% else %}
  service.disabled:
    - name: {{ server.service_freshclam }}
{% endif %}

group_amavis:
  group.present:
    - name: amavis
    - system: True
    - addusers:
      - clamav
    - require:
      - pkg: amavis_packages
    - require_in:
      - service: amavis_service

group_clamav:
  group.present:
    - name: clamav
    - system: True
    - addusers:
      - amavis
    - require:
      - pkg: amavis_packages
    - require_in:
      - service: amavis_service

razor_create:
  cmd.run:
    - name: razor-admin -create
    - creates: /var/lib/amavis/.razor/servers.catalogue.lst
    - user: amavis
    - shell: /bin/bash
    - require:
      - group: group_amavis
    - require_in:
      - service: amavis_service

razor_register:
  cmd.run:
    - name: razor-admin -register
    - creates: /var/lib/amavis/.razor/identity
    - user: amavis
    - shell: /bin/bash
    - require:
      - cmd: razor_create
    - require_in:
      - service: amavis_service

pyzor_discover:
  cmd.wait:
    - name: pyzor discover
    - user: amavis
    - shell: /bin/bash
    - watch:
      - cmd: razor_register
    - require_in:
      - service: amavis_service

amavis_config:
  file.managed:
  - name: /etc/amavis/conf.d/99-salt
  - source: salt://postfix/files/amavis/99-salt
  - template: jinja
  - require:
    - pkg: amavis_packages
  - watch_in:
    - service: amavis_service

{%- endif %}
