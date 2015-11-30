=======
Postfix
=======

Install and configure Postfix.

Available states
================

.. contents::
    :local:

``postfix.server``
------------------

Setup postfix server

``postfix.relay``
------------------

Setup postfix relay

``postfix.backupmx``
------------------

Setup postfix backup MX

Available metadata
==================

.. contents::
    :local:

``metadata.postfix.server``
---------------------------

Setup postfix server

``postfix.relay``
------------------

Setup postfix relay

``postfix.backupmx``
------------------

Setup postfix backup MX

Requirements
============

- linux
- mysql (for mysql backend and postfixadmin)
- apache (for postfixadmin)

Optional
--------

- `glusterfs <https://github.com/tcpcloud/salt-glusterfs-formula>`_ (to serve as mail storage backend)
- `dovecot <https://github.com/tcpcloud/salt-dovecot-formula>`_
- `roundcube <https://github.com/tcpcloud/salt-roundcube-formula>`_

Configuration parameters
========================

For complete list of parameters, please check
``metadata/service/server.yml``

Example reclass
===============

Server
------

.. code-block:: yaml

   classes:
     - service.postfix.server
   parameters:
    _param:
      postfix_origin: mail.eru
      mysql_mailserver_password: Peixeilaephahmoosa2daihoh4yiaThe
    postfix:
      server:
        origin: ${_param:postfix_origin}
        ssl:
          enabled: true
          key: ${_secret:ssl_domain_wild_key}
          cert: ${_secret:ssl_domain_wild_cert}
          chain: ${_secret:ssl_domain_wild_chain}
          # Set smtpd_tls_security_level to encrypt and require TLS encryption
          required: true
    mysql:
      server:
        database:
          mailserver:
            encoding: UTF8
            locale: cs_CZ
            users:
            - name: mailserver
              password: ${_param:mysql_mailserver_password}
              host: 127.0.0.1
              rights: all privileges
    apache:
      server:
        site:
          postfixadmin:
            enabled: true
            type: static
            name: postfixadmin
            root: /usr/share/postfixadmin
            host:
              name: ${_param:postfix_origin}
              aliases:
                - ${linux:system:name}.${linux:system:domain}
                - ${linux:system:name}

Example pillar
==============

Server
------

Setup without postfixadmin:

.. code-block:: yaml

    postfix:
      server:
        origin: ${_param:postfix_origin}
        admin:
          enabled: false

DKIM
~~~~

.. code-block:: yaml

    postfix:
      server:
        dkim:
          enabled: true
          domains:
            - name: example.com
              selector: mail
              key: |
                super_secret_private_key

First you need to generate private and public key, eg.:

.. code-block:: bash

     opendkim-genkey -r -s mail -d example.com

And set public key in your DNS records, see `mail.txt` for public key.

Mailman
~~~~~~~

.. code-block:: yaml

     postfix:
       server:
         mailman:
           enabled: true
           admin_password: SaiS0kai
           lists:
             - name: support
               admin: test@lxc.eru
               password: test
               domain: lxc.eru
               domainweb: lists.lxc.eru
               members:
                 - test@lxc.eru

It's also good idea to mount GlusterFS volume on ``/var/lib/mailman`` for
multi-master setup.

You can also set per-list parameters. For example you can setup private
mailing list with these options:

.. code-block:: yaml

     lists:
       - name: support
         admin: test@lxc.eru
         password: test
         domain: lxc.eru
         domainweb: lists.lxc.eru
         members:
           - test@lxc.eru
         parameters:
           real_name: support
           description: "Support mailing list"
           # Don't be advertised
           advertised: 0
           # Require admin to confirm subscription
           subscribe_policy: 2
           # Show members only to admins
           private_roster: 2
           # Archive only for members
           archive_private: 1

To list all available configuration options for given list, see output of
folliwing command:

.. code-block:: bash

     config_list -o - <list_name>

.. warning:: If you want to have list on your domain, eg. support@example.com
   instead of support@lists.example.com, you may need to set up aliases like
   this, depending on your setup:

   ::

     support-owner@example.com -> support-owner@lists.example.com
     support-admin@example.com -> support-admin@lists.example.com
     support-request@example.com -> support-request@lists.example.com
     support-confirm@example.com -> support-confirm@lists.example.com
     support-join@example.com -> support-join@lists.example.com
     support-leave@example.com -> support-leave@lists.example.com
     support-subscribe@example.com -> support-subscribe@lists.example.com
     support-unsubscribe@example.com -> support-unsubscribe@lists.example.com
     support-bounces@example.com -> support-bounces@lists.example.com
     support@example.com -> support@lists.example.com


Relay
-----

.. code-block:: yaml

    postfix:
      relay:
        # Postfix will listen only on localhost
        interfaces: loopback-only
        host: mail.cloudlab.cz
        domain: cloudlab.cz
        sasl:
          user: test
          password: changeme

Backup MX
---------

.. code-block:: yaml

    postfix:
      backupmx:
        domains:
          - cloudlab.cz
          - lists.cloudlab.cz

Read more
=========

* http://doc.postfix.com/
* http://fog.ccsf.edu/~msapiro/scripts/
* http://wiki.list.org/DOC/Making%20Sure%20Your%20Lists%20Are%20Private
