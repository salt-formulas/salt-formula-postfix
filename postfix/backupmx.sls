{% from "postfix/map.jinja" import backupmx with context %}

{%- if backupmx.enabled %}

include:
- postfix.common

{%- endif %}
