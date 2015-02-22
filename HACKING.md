Hacking on hidden-hippo
=======================

Here's how to setup your development environment so that you can start hacking
on hidden-hippo.

Check out the source
--------------------

    $ git clone git@github.com:beraboris/hidden-hippo
    $ cd hidden-hippo

Setup a dev environment
-----------------------

You have to options when it comes to the dev environment. You can use Vagrant,
which is a magic VM thingy that sets up the whole environment for you. Or you
can setup the environment yourself. Using Vagrant is the easier option.

### Vagrant

If you don't already have it, install [vagrant](https://www.vagrantup.com/downloads.html).
You'll also going to need either VMware or VirtualBox.

Setup the VM with: (This will create a VM with a working dev environment.)

    $ vagrant up

Ssh into the VM with:

    $ vagrant ssh
    $ cd /vagrant
    $ bundle install

Once you're done suspend the vm with:

    $ vagrant suspend

In the VM, the code can be found in `/vagrant`. This is a shared folder that is
automatically setup by vagrant.

### Manual setup

Install ruby. We currently support:

- ruby 1.9.3
- ruby 2.0.0
- ruby 2.1.5
- ruby 2.2.0
- jruby in 1.9 mode

Install bundler:

    $ gem install bundler

Install dependencies

    $ bundle install

Running hidden-hippo
--------------------

    $ bundle exec hh ...

Running tests
-------------

    $ rake

or

    $ rspec spec/...
