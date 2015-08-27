include:
{%- if pillar.postfix.server is defined %}
- postfix.server
{%- endif %}
{%- if pillar.postfix.relay is defined %}
- postfix.relay
{%- endif %}
