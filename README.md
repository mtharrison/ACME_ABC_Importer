#ACME ABC Job Streamer Importer

##Background

ACME Legal use a Windows App called ABC as a CRM for their candidates. The ACME Legal website has a tool called the **Job streamer** which is basically a cron initiated mail script to update candidates of new job opportunities that matched their saved criteria.

Syncronisation however is an issue between these systems with them both having different input mechanisms they have diverged.

##Function
This is a Ruby CLI tool that reads some XML documents (either remotely by FTP or within the local filesystem) and processes the nodes within. Some of these nodes will trigger updates, some creations, some deletions of records within the job streamer database table.

This algorithm has been designed for speed and low memory usage. It averages around 1ms/node. A complete import of ABC with 30,000 records takes around 90 seconds.

##Requirements

To install all requirements run `bundle install` (or if you don't have bundle run `gem install bundler` first) at the project root.

This has been developed with `Ruby 1.9.2`.

##Testing

This tool has 100% test coverage and this should be maintained. To check the current coverage
run `rake coverage`; a report will be placed at `/coverage/index.html`

A complete suite of unit/functional tests is found with `/tests`. To run all tests, run `rake test` at the project root.

##Documentation

* A flowchart explaining the algorithm is found at `/flowchart.png`
* API docs are found at `/doc/index.html`

##Configuration
An environment based config is found in `config.yml`

##Logging
The application will log to a file (`/logs/application.log` in production). Any fatal errors are also SMS'd to the developer.

##Executables
The main executable is location in `/bin/ABCImport`.



---

*Author: Matt Harrison*

*Last Updated:  March 2014*
