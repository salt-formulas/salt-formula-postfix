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

Read more
=========

* http://doc.postfix.com/
