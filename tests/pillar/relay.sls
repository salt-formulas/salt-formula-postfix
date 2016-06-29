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
    ssl:
      enabled: false
  relay:
    enabled: true
    # Relayhost is resolved by MX records of cloudlab.cz
    host: cloudlab.cz
    sasl:
      user: relay@cloudlab.cz
      password: aes9aemiexohm7oohin4Amab9thahgha
    aliases:
      webmaster: root
      hostmaster: root
      mailer-daemon: root
      abuse: root
      security: root
      root: root@tcpcloud.eu
    interfaces: all
  backupmx:
    enabled: false
