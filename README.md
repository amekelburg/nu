DETER
=====

Requirements
------------

* Ruby version 2.1.3
* Redis 2.6.16 or newer

Configuration
-------------

* Review configuration in config.yml
* Update database.yml
* Initialize database

        $ bin/rake db:setup

Testing
-------

    $ bin/rake test:all

Running
-------

    $ foreman start

Deploying
---------

* Review deploy.yml
* Copy config/deploy/production.rb.sample to config/deploy/production.rb
  and update user/server
* Run deployment:

        $ cap production deploy


SPI Request-response log
------------------------

Every request and response to SPI (except for those cached WSDL) are
logged and can be examined. Below are the URLs for the last 10 and 10k
records:

    http://.../admin/spi_log

    http://.../admin/full_spi_log


