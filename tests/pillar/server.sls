postfix:
  server:
    enabled: true
    myhostname: mx01.local
    myorigin: mx01.local
    origin: mx01.local
    mailbox_base: /srv/mail
    pkgs_postfixadmin:
    - 'postfixadmin'
    - 'php7.0-imap'
    dovecot_lmtp:
      enabled: true
      type: unix
      address: private/dovecot-lmtp
    message_size_limit: 25000000
    aliases:
      webmaster: root
      hostmaster: root
      postmaster: root
      mailer-daemon: root
      abuse: root
      security: root
      root: root@mx01.local
    admin:
      enabled: true
      encrypt: "md5"
      url: "/admin"
      # Default password is changeme, and this is what you should do
      setup_password: 'dcae0c85ae2ec6ed7922a98d96a4f891:34de2e58483b2e6df1eb984e030ba7a405dfa1d0'
      email: postmaster@mx01.local
      default_aliases:
        root: root@mx01.local
        abuse: abuse@mx01.local
        hostmaster: hostmaster@mx01.local
        postmaster: postmaster@mx01.local
        webmaster: webmaster@mx01.local
      vacation:
        enabled: false
        domain: autoreply.mx01.local
      footer:
        show_text: true
        text: "Return to webmail"
        link: "https://mx01.local"
    user:
      name: vmail
      group: vmail
      uid: 125
      gid: 125
      home: /srv
    mysql:
      user: mailserver
      database: mailserver
      password: password
      host: 127.0.0.1
    ssl:
      enabled: false
    dkim:
      enabled: false
      trusted_hosts:
        - 127.0.0.1
        - ::1
        - localhost
        - mx01.local
    mailman:
      enabled: true
      admin_password: changeme
      default_domain: lists.mx01.local
      send_reminders: false
      use_https: false
      domains:
        - lists.mx01.local
      lists:
        # Default list, required by mailman itself
        - name: mailman
          admin: root@mx01.local
          password: password
          # Domain to which list belongs to, eg. example.com for
          # list on mailman@example.com
          domain: mx01.local
          # Lists web interface hostname (eg. lists.example.com)
          domainweb: lists.mx01.local
          parameters:
            advertised: 0
            subscribe_policy: 2
            private_roster: 2
            archive_private: 1
    amavis:
      enabled: true
      processes: 2
      virus_destiny: D_DISCARD
      banned_destiny: D_PASS
      spam_destiny: D_PASS
      bad_header_destiny: D_PASS
      spamassassin:
        subject_tag: '[SPAM]'
        tag_level: '2.0'
        tag2_level: '6.31'
        kill_level: '6.31'
        dsn_cutoff_level: '10'
  relay:
    enabled: false
  backupmx:
    enabled: false
