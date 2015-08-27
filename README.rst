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

- `glusterfs <https://github.com/tcpcloud/salt-glusterfs-formula>`_ (to serve as mail storage backend
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
