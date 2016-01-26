postfix:
  server:
    enabled: false
    myhostname: mx01.local
    myorigin: mx01.local
    message_size_limit: 25000000
    amavis:
      enabled: false
    mailman:
      enabled: false
    aliases:
      webmaster: root
      hostmaster: root
      postmaster: root
      mailer-daemon: root
      abuse: root
      security: root
      root: root@local
  relay:
    enabled: false
  backupmx:
    enabled: true
    queue:
      lifetime: 5d
    domains:
    - local
    - magicpony.org
    - example.com
