include:
{%- if pillar.postfix.server is defined %}
- postfix.server
{%- endif %}
{%- if pillar.postfix.relay is defined %}
- postfix.relay
{%- endif %}
{%- if pillar.postfix.backupmx is defined %}
- postfix.backupmx
{%- endif %}
