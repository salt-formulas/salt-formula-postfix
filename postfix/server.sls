{% from "postfix/map.jinja" import server with context %}

{%- if server.enabled %}

include:
- postfix.common

{%- endif %}
