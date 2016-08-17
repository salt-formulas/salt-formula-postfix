
Continuous Integration
======================

We are using Jenkins to spin a kitchen instances in Docker or OpenStack environment.

If you would like to repeat, then you may use ``.kitchen.<backend>.yml`` configuration yaml in the main directory
to override ``.kitchen.yml`` at some points.
Usage: ``KITCHEN_LOCAL_YAML=.kitchen.docker.yml kitchen verify server-ubuntu-1404 -t tests/integration``.

Be aware of fundamental differences of backends. The formula verification scripts are primarily tested with
Vagrant driver.


CI performs following (Kitchen Test) actions on each instance:

1. *create*, provision an test instance (VM, container)
2. *converge*, run a provisioner (shell script, kitchen-salt)
3. *verify*, run a verification (inspec, other may be added)
4. *destroy*


Test Kitchen
------------


To install Test Kitchen is as simple as:

.. code-block:: shell

  # install kitchen
  gem install test-kitchen

  # install required plugins
  gem install kitchen-vagrant kitchen-docker kitchen-salt

  # install additional plugins & tools
  gem install kitchen-openstack kitchen-inspec busser-serverspec

  kitchen list
  kitchen test

of course you have to have installed Ruby and it's package manager `gem <https://rubygems.org/>`_ first.

One may be satisfied installing it system-wide right from OS package manager which is preferred installation method.
For advanced users or the sake of complex environments you may use `rbenv <https://github.com/rbenv/rbenv>`_ for user side ruby installation.

 * https://github.com/rbenv/rbenv
 * http://kitchen.ci/docs/getting-started/installing

An example steps then might be:

.. code-block:: shell

  # get rbenv
  git clone https://github.com/rbenv/rbenv.git ~/.rbenv

  # configure
  cd ~/.rbenv && src/configure && make -C src     # don't worry if it fails
  echo 'export PATH="$HOME/.rbenv/bin:$PATH"'     >> ~/.bash_profile
  cd ~/.rbenv; git fetch

  # list all available versions:
  rbenv install -l

  #install a Ruby version:
  rbenv install 2.0.0-p247

  # activate
  rbenv local 2.0.0-p247

  # install test kitchen
  gem install test-kitchen

An optional ``Gemfile`` in the main directory may contain Ruby dependencies to be required for Test Kitchen workflow.
To install them you have to install first ``gem install bundler`` and then run ``bundler install``.
