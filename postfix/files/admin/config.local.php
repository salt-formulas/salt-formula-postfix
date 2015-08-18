{%- from "postfix/map.jinja" import server with context %}
<?php

$CONF['setup_password'] = '{{ server.admin.setup_password }}';
$CONF['postfix_admin_url'] = '{{ server.admin.url }}';
$CONF['admin_email'] = '{{ server.admin.email }}';

$CONF['encrypt'] = '{{ server.admin.encrypt }}';
$CONF['vacation_domain'] = '{{ server.admin.vacation.domain }}';

$CONF['domain_path'] = 'YES';
$CONF['backup'] = 'NO';
$CONF['used_quotas'] = 'YES';
$CONF['new_quota_table'] = 'YES';

$CONF['show_footer_text'] = 'NO';

{%- if server.admin.default_aliases %}
$CONF['default_aliases'] = array (
    {%- for alias, goto in server.admin.default_aliases.iteritems() %}
    '{{ alias }}' => '{{ goto }}',
    {%- endfor %}
);
{%- endif %}

/* vim: set expandtab softtabstop=4 tabstop=4 shiftwidth=4: */
