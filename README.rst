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
           distributed: true
           use_https: false
           lists:
             - name: support
               admin: test@lxc.eru
               password: test
               domain: lxc.eru
               domainweb: lists.lxc.eru
               members:
                 - test@lxc.eru

It's also good idea to mount GlusterFS volume on ``/var/lib/mailman`` for
multi-master setup. In that case distributed has to be true to bind-mount
qfiles directory which must not be shared.

Parameter ``use_https`` needs to be set before setting up any lists, otherwise
you need to fix lists urls manually using:

.. code-block:: bash

    withlist -l -a -r fix_url

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


Development and testing
=======================

Development and test workflow with `Test Kitchen <http://kitchen.ci>`_ and
`kitchen-salt <https://github.com/simonmcc/kitchen-salt>`_ provisioner plugin.

Test Kitchen is a test harness tool to execute your configured code on one or more platforms in isolation.
There is a ``.kitchen.yml`` in main directory that defines *platforms* to be tested and *suites* to execute on them.

Kitchen CI can spin instances locally or remote, based on used *driver*.
For local development ``.kitchen.yml`` defines a `vagrant <https://github.com/test-kitchen/kitchen-vagrant>`_ or 
`docker  <https://github.com/test-kitchen/kitchen-docker>`_ driver.

To use backend drivers or implement your CI follow the section `INTEGRATION.rst#Continuous Integration`__.

A listing of scenarios to be executed:

.. code-block:: shell

  $ kitchen list

  Instance                    Driver   Provisioner  Verifier  Transport  Last Action

  server-bento-ubuntu-1404    Vagrant  SaltSolo     Busser    Ssh        <Not Created>
  server-bento-ubuntu-1604    Vagrant  SaltSolo     Busser    Ssh        Created
  server-bento-centos-71      Vagrant  SaltSolo     Busser    Ssh        <Not Created>
  relay-bento-ubuntu-1404     Vagrant  SaltSolo     Busser    Ssh        <Not Created>
  relay-bento-ubuntu-1604     Vagrant  SaltSolo     Busser    Ssh        <Not Created>
  relay-bento-centos-71       Vagrant  SaltSolo     Busser    Ssh        <Not Created>
  backupmx-bento-ubuntu-1404  Vagrant  SaltSolo     Busser    Ssh        <Not Created>
  backupmx-bento-ubuntu-1604  Vagrant  SaltSolo     Busser    Ssh        <Not Created>
  backupmx-bento-centos-71    Vagrant  SaltSolo     Busser    Ssh        <Not Created>


The `Busser <https://github.com/test-kitchen/busser>`_ *Verifier* is used to setup and run tests
implementated in `<repo>/test/integration`. It installs the particular driver to tested instance
(`Serverspec <https://github.com/neillturner/kitchen-verifier-serverspec>`_,
`InSpec <https://github.com/chef/kitchen-inspec>`_, Shell, Bats, ...) prior the verification is executed.


Usage:

.. code-block:: shell

  # manually
  kitchen [test || [create|converge|verify|exec|login|destroy|...]] -t tests/integration

  # or with provided Makefile within CI pipeline
  make kitchen



Read more
=========

* http://doc.postfix.com/
* http://fog.ccsf.edu/~msapiro/scripts/
* http://wiki.list.org/DOC/Making%20Sure%20Your%20Lists%20Are%20Private

Documentation and Bugs
======================

To learn how to install and update salt-formulas, consult the documentation
available online at:

    http://salt-formulas.readthedocs.io/

In the unfortunate event that bugs are discovered, they should be reported to
the appropriate issue tracker. Use Github issue tracker for specific salt
formula:

    https://github.com/salt-formulas/salt-formula-postfix/issues

For feature requests, bug reports or blueprints affecting entire ecosystem,
use Launchpad salt-formulas project:

    https://launchpad.net/salt-formulas

You can also join salt-formulas-users team and subscribe to mailing list:

    https://launchpad.net/~salt-formulas-users

Developers wishing to work on the salt-formulas projects should always base
their work on master branch and submit pull request against specific formula.

    https://github.com/salt-formulas/salt-formula-postfix

Any questions or feedback is always welcome so feel free to join our IRC
channel:

    #salt-formulas @ irc.freenode.net
