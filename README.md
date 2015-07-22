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

    /admin/spi_log

    /admin/full_spi_log

Seeding
-------

After the database is reset you might want to seed it with data. Follow
to:

    /admin/seed

You will be prompted to enter the `deterboss` user password. Upon
submission you should see the log of the seeding script. Supported
browsers:

* Firefox 10+
* Chrome 26+
* Safari 7.0+
* Opera 12+
* iOS Safari 7.1+
* Android Browser 4.4+
* Chrome for Android 42+

Upon completion you will see "FINISHED: ok" message. At this point, you
may want to check the SPI log at:

    /admin/full_spi_log

