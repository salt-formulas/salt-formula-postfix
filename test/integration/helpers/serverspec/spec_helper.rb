require 'serverspec'

set :backend, :exec
set :path, '/sbin:/usr/local/sbin:$PATH'

def postfix_conf_path
  if os[:family] == 'solaris'
    '/opt/omni/etc/postfix/'
  else
    '/etc/postfix'
  end
end
