{% from "postfix/map.jinja" import server with context %}

{%- if server.mailman.enabled %}

mailman_packages:
  pkg.installed:
    - name: mailman

mailman_service:
  service.running:
    - name: mailman
    - require:
      - pkg: mailman_packages

# This should be imho setup this way by mailman package itself in the
# same manner as roundcube
mailman_apache_conf:
  file.managed:
  - name: /etc/apache2/conf-available/mailman.conf
  - source: salt://postfix/files/mailman/apache.conf
  - template: jinja

mailman_apache_conf_enable:
  cmd.run:
    - name: a2enconf mailman
    - creates: /etc/apache2/conf-enabled/mailman.conf
    - require:
      - file: mailman_apache_conf

mailman_config:
  file.managed:
  - name: /etc/mailman/mm_cfg.py
  - source: salt://postfix/files/mailman/mm_cfg.py
  - template: jinja
  - require:
    - pkg: mailman_packages
  - watch_in:
    - service: mailman_service

mailman_genaliases:
  cmd.wait:
  - name: /usr/lib/mailman/bin/genaliases
  - watch:
    - file: mailman_config

mailman_transport:
  file.managed:
  - name: /etc/postfix/transport
  - source: salt://postfix/files/mailman/transport
  - template: jinja

mailman_transport_postmap:
  cmd.wait:
    - name: postmap -v /etc/postfix/transport
    - watch:
      - file: mailman_transport

{%- if server.mailman.get('distributed', False) %}
mailman_var_spool:
  file.directory:
    - name: /var/spool/mailman
    - mode: 2775
    - owner: list
    - group: list
    - require:
      - pkg: mailman_packages

mailman_qfiles_bind:
  mount.mounted:
    - name: /var/lib/mailman/qfiles
    - device: /var/spool/mailman
    - fstype: none
    - opts: bind
    - require:
      - file: mailman_var_spool
    - watch_in:
      - service: mailman_service
{%- endif %}

{%- for mlist in server.mailman.lists %}
mailman_newlist_{{ mlist.name }}:
  cmd.run:
    - name: newlist -q -e {{ mlist.domain }} -u {{ mlist.domainweb }} {{ mlist.name }} {{ mlist.admin }} {{ mlist.password }}
    - creates: /var/lib/mailman/lists/{{ mlist.name }}
    - require:
      - pkg: mailman_packages
    - require_in:
      - service: mailman_service

{%- if mlist.parameters is defined %}
mailman_{{ mlist.name }}_preferences_file:
  file.managed:
  - name: /var/tmp/{{ mlist.name }}_preferences
  - source: salt://postfix/files/mailman/list_preferences
  - mode: 600
  - template: jinja
  - defaults:
      list_name: {{ mlist.name }}
  - require:
    - cmd: mailman_newlist_{{ mlist.name }}

mailman_{{ mlist.name }}_preferences:
  cmd.watch:
    - name: config_list -v -i /var/tmp/{{ mlist.name }}_preferences {{ mlist.name }}
    - watch:
      - file: mailman_{{ mlist.name }}_preferences_file
{%- endif %}

{%- if mlist.members is defined %}
{%- for member in mlist.members %}

mailman_{{ mlist.name }}_member_{{ member }}:
  cmd.run:
    - name: 'echo -e "{{ member }}" | add_members -r - {{ mlist.name }}'
    - unless: "list_members {{ mlist.name }} | grep {{ member }}"
    - require:
      - cmd: mailman_newlist_{{ mlist.name }}

{%- endfor %}
{%- endif %}

{%- endfor %}

{%- endif %}
